Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73D157BC2E
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 19:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbiGTRBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 13:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiGTRBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 13:01:22 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B5367C81;
        Wed, 20 Jul 2022 10:01:17 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VJxkm3h_1658336471;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VJxkm3h_1658336471)
          by smtp.aliyun-inc.com;
          Thu, 21 Jul 2022 01:01:12 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        zmlcc@linux.alibaba.com, hans@linux.alibaba.com,
        zhiyuan2048@linux.alibaba.com, herongguang@linux.alibaba.com
Subject: [RFC net-next 1/1] net/smc: SMC for inter-VM communication
Date:   Thu, 21 Jul 2022 01:00:48 +0800
Message-Id: <20220720170048.20806-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL,WEIRD_QUOTING autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

# Background

We (Alibaba Cloud) have already used SMC in cloud environment to
transparently accelerate TCP applications with ERDMA [1]. Nowadays,
there is a common scenario that deploy containers (which runtime is
based on lightweight virtual machine) on ECS (Elastic Compute Service),
and the containers may want to be scheduled on the same host in order to
get higher performance of network, such as AI, big data or other
scenarios that are sensitive with bandwidth and latency. Currently, the
performance of inter-VM is poor and CPU resource is wasted (see
#Benchmark virtio). This scenario has been discussed many times, but a
solution for a common scenario for applications is missing [2] [3] [4].

# Design

In inter-VM scenario, we use ivshmem (Inter-VM shared memory device)
which is modeled by QEMU [5]. With it, multiple VMs can access one
shared memory. This shared memory device is statically created by host
and shared to desired guests. The device exposes as a PCI BAR, and can
interrupt its peers (ivshmem-doorbell).

In order to use ivshmem in SMC, we write a draft device driver as a
bridge between SMC and ivshmem PCI device. To make it easier, this
driver acts like a SMC-D device in order to fit in SMC without modifying
the code, which is named ivpci (see patch #1).

  ┌───────────────────────────────────────┐
  │  ┌───────────────┐ ┌───────────────┐  │
  │  │      VM1      │ │      VM2      │  │
  │  │┌─────────────┐│ │┌─────────────┐│  │
  │  ││ Application ││ ││ Application ││  │
  │  │├─────────────┤│ │├─────────────┤│  │
  │  ││     SMC     ││ ││     SMC     ││  │
  │  │├─────────────┤│ │├─────────────┤│  │
  │  ││    ivpci    ││ ││    ivpci    ││  │
  │  └└─────────────┘┘ └└─────────────┘┘  │
  │        x  *               x  *        │
  │        x  ****************x* *        │
  │        x  xxxxxxxxxxxxxxxxx* *        │
  │        x  x                * *        │
  │  ┌───────────────┐ ┌───────────────┐  │
  │  │shared memories│ │ivshmem-server │  │
  │  └───────────────┘ └───────────────┘  │
  │                HOST A                 │
  └───────────────────────────────────────┘
   *********** Control flow (interrupt)
   xxxxxxxxxxx Data flow (memory access)

Inside ivpci driver, it implements almost all the operations of SMC-D
device. It can be divided into two parts:

- control flow, most of it is same with SMC-D, use ivshmem trigger
  interruptions in ivpci and process CDC flow.

- data flow, the shared memory of each connection is one large region
  and divided into two part for local and remote RMB. Every writer
  syscall copies data to sndbuf and calls ISM's move_data() to move data
  to remote RMB in ivshmem and interrupt remote. And reader then
  receives interruption and check CDC message, consume data if cursor is
  updated.

# Benchmark

Current POC of ivpci is unstable and only works for single SMC
connection. Here is the brief data: 

Items         Latency (pingpong)    Throughput (64KB)
TCP (virtio)   19.3 us                3794.185 MBps
TCP (SR-IOV)   13.2 us                3948.792 MBps
SMC (ivshmem)   6.3 us               11900.269 MBps

Test environments:

- CPU Intel Xeon Platinum 8 core, mem 32 GiB
- NIC Mellanox CX4 with 2 VFs in two different guests
- using virsh to setup virtio-net + vhost
- using sockperf and single connection
- SMC + ivshmem throughput uses one-copy (userspace -> kernel copy)
  with intrusive modification of SMC (see patch #1), latency (pingpong)
  use two-copy (user -> kernel and move_data() copy, patch version).

With the comparison, SMC with ivshmem gets 3-4x bandwidth and a half
latency.

TCP + virtio is the most usage solution for guest, it gains lower
performance. Moreover, it consumes extra thread with full CPU core
occupied in host to transfer data, wastes more CPU resource. If the host
is very busy, the performance will be worse.

# Discussion

This RFC and solution is still in early stage, so we want to come it up
as soon as possible and fully discuss with IBM and community. We have
some topics putting on the table:

1. SMC officially supports this scenario.

SMC + ivshmem shows huge improvement when communicating inter VMs. SMC-D
and mocking ISM device might not be the official solution, maybe another
extension for SMC besides SMC-R and SMC-D. So we are wondering if SMC
would accept this idea to fix this scenario? Are there any other
possibilities?

2. Implementation of SMC for inter-VM.

SMC is used in container and cloud environment, maybe we can propose a
new device and new protocol if possible in these new scenarios to solve
this problem. 

3. Standardize this new protocol and device.

SMC-R has an open RFC 7609, so can this new device or protocol like
SMC-D can be standardized. There is a possible option that proposing a
new device model in QEMU + virtio ecosystem and SMC supports this
standard virtio device, like [6].

If there are any problems, please point them out.

Hope to hear from you, thank you. 

[1] https://lwn.net/Articles/879373/
[2] https://projectacrn.github.io/latest/tutorials/enable_ivshmem.html
[3] https://dl.acm.org/doi/10.1145/2847562
[4] https://hal.archives-ouvertes.fr/hal-00368622/document
[5] https://github.com/qemu/qemu/blob/master/docs/specs/ivshmem-spec.txt
[6] https://github.com/siemens/jailhouse/blob/master/Documentation/ivshmem-v2-specification.md

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 Makefile |  23 +++
 ivpci.c  | 453 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 476 insertions(+)
 create mode 100644 Makefile
 create mode 100644 ivpci.c

diff --git a/Makefile b/Makefile
new file mode 100644
index 000000000000..5f3d27f1793c
--- /dev/null
+++ b/Makefile
@@ -0,0 +1,23 @@
+# obj-m is a list of what kernel modules to build.  The .o and other
+# objects will be automatically built from the corresponding .c file -
+# no need to list the source files explicitly.
+
+obj-m := ivpci.o
+
+# KDIR is the location of the kernel source.  The current standard is
+# to link to the associated source tree from the directory containing
+# the compiled modules.
+KDIR  := /root/net-next
+
+# PWD is the current working directory and the location of our module
+# source files.
+PWD   := $(shell pwd)
+
+# default is the default make target.  The rule here says to run make
+# with a working directory of the directory containing the kernel
+# source and compile only the modules in the PWD (local) directory.
+default:
+	$(MAKE) -C $(KDIR) M=$(PWD) modules
+
+clean:
+	rm -f *.ko *.o ivpci.mod.c Module.symvers ivpci.mod modules.order .*.cmd
diff --git a/ivpci.c b/ivpci.c
new file mode 100644
index 000000000000..841683df649a
--- /dev/null
+++ b/ivpci.c
@@ -0,0 +1,453 @@
+#define KMSG_COMPONENT "ivpci"
+#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/pci.h>
+#include <linux/pci_regs.h>
+#include <linux/device.h>
+#include <linux/uaccess.h>
+#include <linux/interrupt.h>
+#include <linux/ioctl.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+#include <net/smc.h>
+
+#define DRV_NAME		"ivpci"
+#define DRV_VERSION		"0.1"
+#define DRV_FILE_FMT		DRV_NAME"-%d"
+
+#define IVPOSITION_OFF		0x08 /* VM ID*/
+#define DOORBELL_OFF		0x0c /* Doorbell */
+
+struct ivpci_private {
+	struct pci_dev		*dev;
+	struct smcd_dev		*smcd;
+	int			minor;
+
+	u8			revision;
+	u32			ivposition;
+
+	u8 __iomem		*base_addr;
+	u8 __iomem		*regs_addr;
+
+	unsigned int		bar0_addr;
+	unsigned int		bar0_len;
+	unsigned int		bar1_addr;
+	unsigned int		bar1_len;
+	unsigned int		bar2_addr;
+	unsigned int		bar2_len;
+
+	char			(*msix_names)[256];
+	struct msix_entry	*msix_entries;
+	int			nvectors;
+};
+
+struct ism_systemeid {
+	u8      seid_string[24];
+	u8      serial_number[4];
+	u8      type[4];
+};
+
+static struct ism_systemeid SYSTEM_EID = {
+	.seid_string = "IVPCI-ISMSEID00000000",
+	.serial_number = "0000",
+	.type = "0000",
+};
+
+static int		g_ivpci_major;
+static struct class	*g_ivpci_class;
+static int		ivpci_index;
+
+static struct pci_device_id ivpci_id_table[] = {
+	{ 0x1af4, 0x1110, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ 0 },
+};
+MODULE_DEVICE_TABLE(pci, ivpci_id_table);
+
+static irqreturn_t ivpci_handle_interrupt(int irq, void *data);
+
+static int ivpci_request_msix_vectors(struct ivpci_private *ivpci_dev, int n)
+{
+	int ret, i;
+
+	ret = -EINVAL;
+
+	pr_info("request msi-x vectors: %d\n", n);
+
+	ivpci_dev->nvectors = n;
+
+	ivpci_dev->msix_entries = kmalloc(n * sizeof(struct msix_entry),
+					  GFP_KERNEL);
+	if (ivpci_dev->msix_entries == NULL) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	ivpci_dev->msix_names = kmalloc(n * sizeof(*ivpci_dev->msix_names),
+					GFP_KERNEL);
+	if (ivpci_dev->msix_names == NULL) {
+		ret = -ENOMEM;
+		goto free_entries;
+	}
+
+	for (i = 0; i < n; i++) {
+		ivpci_dev->msix_entries[i].entry = i;
+	}
+
+	ret = pci_enable_msix_exact(ivpci_dev->dev, ivpci_dev->msix_entries, n);
+	if (ret) {
+		pr_err("unable to enable msix: %d\n", ret);
+		goto free_names;
+	}
+
+	for (i = 0; i < ivpci_dev->nvectors; i++) {
+		snprintf(ivpci_dev->msix_names[i], sizeof(*ivpci_dev->msix_names),
+			 "%s%d-%d", DRV_NAME, ivpci_dev->minor, i);
+
+		ret = request_irq(ivpci_dev->msix_entries[i].vector,
+				  ivpci_handle_interrupt, 0, ivpci_dev->msix_names[i],
+				  ivpci_dev);
+
+		if (ret) {
+			pr_err("unable to allocate irq for " \
+			       "msix entry %d with vector %d\n", i,
+			       ivpci_dev->msix_entries[i].vector);
+			goto release_irqs;
+		}
+
+		pr_info("irq for msix entry: %d, vector: %d\n",
+			i, ivpci_dev->msix_entries[i].vector);
+	}
+
+	return 0;
+
+release_irqs:
+	for ( ; i > 0; i--) {
+		free_irq(ivpci_dev->msix_entries[i - 1].vector, ivpci_dev);
+	}
+	pci_disable_msix(ivpci_dev->dev);
+free_names:
+	kfree(ivpci_dev->msix_names);
+free_entries:
+	kfree(ivpci_dev->msix_entries);
+error:
+	return ret;
+}
+
+static void ivpci_free_msix_vectors(struct ivpci_private *ivpci_dev)
+{
+	int i;
+
+	for (i = ivpci_dev->nvectors; i > 0; i--) {
+		free_irq(ivpci_dev->msix_entries[i - 1].vector, ivpci_dev);
+	}
+	pci_disable_msix(ivpci_dev->dev);
+
+	kfree(ivpci_dev->msix_names);
+	kfree(ivpci_dev->msix_entries);
+}
+
+static irqreturn_t ivpci_handle_interrupt(int irq, void *data)
+{
+	struct ivpci_private *ivpci_dev = data;
+
+	/* XXX: only 0 dmb works for now */
+	smcd_handle_irq(ivpci_dev->smcd, 0);
+
+	return IRQ_HANDLED;
+}
+
+static int ivpci_move(struct smcd_dev *smcd, u64 dmb_tok, unsigned int idx,
+		      bool signal, unsigned int offset, void *data, unsigned int size)
+{
+	struct ivpci_private *ivpci_dev = smcd->priv;
+	u32 value = dmb_tok;
+
+	/* XXX: using memcpy makes it easy to implement, one-copy should be
+	 * implemented in future version. We can move this memcpy into signal
+	 * condition to mock one-copy scence. */
+	memcpy(ivpci_dev->base_addr + (1024 * 1024 * dmb_tok) + offset,
+	       data, size);
+
+	if (signal) {
+		value = (dmb_tok << 16) | 1;
+
+		writel(value, ivpci_dev->regs_addr + DOORBELL_OFF);
+	}
+	return 0;
+}
+
+static int ivpci_query_rgid(struct smcd_dev *smcd, u64 rgid, u32 vid_valid,
+			    u32 vid)
+{
+	pr_info("ivpci_query_rgid\n");
+	return 0;
+}
+
+static int ivpci_register_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
+{
+	struct ivpci_private *ivpci_dev = smcd->priv;
+
+	pr_info("ivpci_register_dmb: sba %u rgid %llu len %u\n",
+		dmb->sba_idx, dmb->rgid, dmb->dmb_len);
+
+	dmb->dmb_tok = ivpci_dev->smcd->local_gid;
+
+	/* XXX: this simply divides into two parts, so only single connection
+	 * works */
+	dmb->cpu_addr = ivpci_dev->base_addr + (1024 * 1024 * dmb->dmb_tok);
+	return 0;
+}
+
+static int ivpci_unregister_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
+{
+	pr_info("ivpci_unregister_dmb\n");
+	return 0;
+}
+
+static int ivpci_add_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
+{
+	pr_info("ivpci_add_vlan_id\n");
+	return 0;
+}
+
+static int ivpci_del_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
+{
+	pr_info("ivpci_del_vlan_id\n");
+	return 0;
+}
+
+static int ivpci_signal_ieq(struct smcd_dev *smcd, u64 rgid, u32 trigger_irq,
+			    u32 event_code, u64 info)
+{
+	pr_info("ivpci_signal_ieq\n");
+	return 0;
+}
+
+static void ivpci_get_system_eid(struct smcd_dev *smcd, u8 **eid)
+{
+	*eid = &SYSTEM_EID.seid_string[0];
+	pr_info("ivpci_get_system_eid\n");
+}
+
+static u16 ivpci_get_chid(struct smcd_dev *smcd)
+{
+	struct ivpci_private *ivpci_dev;
+
+	ivpci_dev = (struct ivpci_private *)smcd->priv;
+	if (!ivpci_dev || !ivpci_dev->dev)
+		return 0;
+
+	return ivpci_dev->ivposition;
+}
+
+static const struct smcd_ops ism_ops = {
+	.query_remote_gid = ivpci_query_rgid,
+	.register_dmb = ivpci_register_dmb,
+	.unregister_dmb = ivpci_unregister_dmb,
+	.add_vlan_id = ivpci_add_vlan_id,
+	.del_vlan_id = ivpci_del_vlan_id,
+	.signal_event = ivpci_signal_ieq,
+	.move_data = ivpci_move,
+	.get_system_eid = ivpci_get_system_eid,
+	.get_chid = ivpci_get_chid,
+};
+
+static int ivpci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
+{
+	int ret;
+	struct ivpci_private *ivpci_dev;
+	dev_t devno;
+
+	dev_set_name(&pci_dev->dev, "ivpci%u", ivpci_index++);
+
+	ret = pci_enable_device(pci_dev);
+	if (ret < 0) {
+		pr_err("unable to enable device: %d\n", ret);
+		goto out;
+	}
+
+	ret = pci_request_regions(pci_dev, DRV_NAME);
+	if (ret < 0) {
+		pr_err("unable to reserve resources: %d\n", ret);
+		goto disable_device;
+	}
+
+	ivpci_dev = kzalloc(sizeof(struct virtio_private *), GFP_KERNEL);
+	if (!ivpci_dev)
+		goto release_regions;
+
+	pci_read_config_byte(pci_dev, PCI_REVISION_ID, &ivpci_dev->revision);
+
+	pr_info("device %d:%d, revision: %d\n",
+		g_ivpci_major, ivpci_dev->minor, ivpci_dev->revision);
+
+	ivpci_dev->bar0_addr = pci_resource_start(pci_dev, 0);
+	ivpci_dev->bar0_len = pci_resource_len(pci_dev, 0);
+	ivpci_dev->bar1_addr = pci_resource_start(pci_dev, 1);
+	ivpci_dev->bar1_len = pci_resource_len(pci_dev, 1);
+	ivpci_dev->bar2_addr = pci_resource_start(pci_dev, 2);
+	ivpci_dev->bar2_len = pci_resource_len(pci_dev, 2);
+
+	pr_info("BAR0: 0x%0x, %d\n", ivpci_dev->bar0_addr,
+		ivpci_dev->bar0_len);
+	pr_info("BAR1: 0x%0x, %d\n", ivpci_dev->bar1_addr,
+		ivpci_dev->bar1_len);
+	pr_info("BAR2: 0x%0x, %d\n", ivpci_dev->bar2_addr,
+		ivpci_dev->bar2_len);
+
+	ivpci_dev->regs_addr = ioremap(ivpci_dev->bar0_addr, ivpci_dev->bar0_len);
+	if (!ivpci_dev->regs_addr) {
+		pr_err("unable to ioremap bar0, size: %d\n",
+		       ivpci_dev->bar0_len);
+		goto release_regions;
+	}
+
+	ivpci_dev->base_addr = ioremap(ivpci_dev->bar2_addr, ivpci_dev->bar2_len);
+	if (!ivpci_dev->base_addr) {
+		pr_err("unable to ioremap bar2, size: %d\n",
+		       ivpci_dev->bar2_len);
+		goto iounmap_bar0;
+	}
+	pr_info("BAR2 map: %p\n", ivpci_dev->base_addr);
+
+	devno = MKDEV(g_ivpci_major, ivpci_dev->minor);
+	if (device_create(g_ivpci_class, NULL, devno, NULL, DRV_FILE_FMT,
+			  ivpci_dev->minor) == NULL) {
+		pr_err("unable to create device file: %d:%d\n",
+		       g_ivpci_major, ivpci_dev->minor);
+		goto iounmap_bar2;
+	}
+
+	ivpci_dev->smcd = smcd_alloc_dev(&pci_dev->dev, dev_name(&pci_dev->dev),
+					 &ism_ops, 1);
+	if (!ivpci_dev->smcd) {
+		pr_err("unable to alloc smcd dev\n");
+		goto destroy_device;
+	}
+	ivpci_dev->smcd->priv = ivpci_dev;
+
+	ivpci_dev->dev = pci_dev;
+	pci_set_drvdata(pci_dev, ivpci_dev);
+
+	if (ivpci_dev->revision == 1) {
+		/* Only process the MSI-X interrupt. */
+		ivpci_dev->ivposition = ioread32(ivpci_dev->regs_addr + IVPOSITION_OFF);
+		ivpci_dev->smcd->local_gid = ivpci_dev->ivposition;
+
+		pr_info("device ivposition: %u, MSI-X: %s\n",
+			ivpci_dev->ivposition,
+			(ivpci_dev->ivposition == 0) ? "no": "yes");
+
+		if (ivpci_dev->ivposition != 0) {
+			ret = ivpci_request_msix_vectors(ivpci_dev, 4);
+			if (ret != 0) {
+				goto smcd_free;
+			}
+		}
+	}
+
+	ret = smcd_register_dev(ivpci_dev->smcd);
+	if (ret) {
+		pr_err("unable to register smcd dev\n");
+		goto smcd_free;
+	}
+
+	pr_info("device probed: %s\n", pci_name(pci_dev));
+	return 0;
+
+smcd_free:
+	smcd_free_dev(ivpci_dev->smcd);
+destroy_device:
+	devno = MKDEV(g_ivpci_major, ivpci_dev->minor);
+	device_destroy(g_ivpci_class, devno);
+	ivpci_dev->dev = NULL;
+iounmap_bar2:
+	iounmap(ivpci_dev->base_addr);
+iounmap_bar0:
+	iounmap(ivpci_dev->regs_addr);
+release_regions:
+	pci_release_regions(pci_dev);
+disable_device:
+	pci_disable_device(pci_dev);
+out:
+	pci_set_drvdata(pci_dev, NULL);
+	return ret;
+}
+
+static void ivpci_remove(struct pci_dev *pci_dev)
+{
+	int devno;
+	struct ivpci_private *ivpci_dev;
+
+	pr_info("removing ivpci device: %s\n", pci_name(pci_dev));
+
+	ivpci_dev = pci_get_drvdata(pci_dev);
+	BUG_ON(ivpci_dev == NULL);
+
+	smcd_free_dev(ivpci_dev->smcd);
+
+	ivpci_free_msix_vectors(ivpci_dev);
+
+	ivpci_dev->dev = NULL;
+
+	devno = MKDEV(g_ivpci_major, ivpci_dev->minor);
+	device_destroy(g_ivpci_class, devno);
+
+	iounmap(ivpci_dev->base_addr);
+	iounmap(ivpci_dev->regs_addr);
+
+	pci_release_regions(pci_dev);
+	pci_disable_device(pci_dev);
+	pci_set_drvdata(pci_dev, NULL);
+}
+
+static struct pci_driver ivpci_driver = {
+	.name       = DRV_NAME,
+	.id_table   = ivpci_id_table,
+	.probe      = ivpci_probe,
+	.remove     = ivpci_remove,
+};
+
+static int __init ivpci_init(void)
+{
+	int ret = -1;
+
+	g_ivpci_class = class_create(THIS_MODULE, DRV_NAME);
+	if (g_ivpci_class == NULL) {
+		pr_err("unable to create the struct class\n");
+		goto out;
+	}
+
+	ret = pci_register_driver(&ivpci_driver);
+	if (ret < 0) {
+		pr_err("unable to register driver: %d\n", ret);
+		goto destroy_class;
+	}
+
+	return 0;
+
+destroy_class:
+	class_destroy(g_ivpci_class);
+out:
+	return ret;
+}
+
+static void __exit ivpci_exit(void)
+{
+	pci_unregister_driver(&ivpci_driver);
+	class_destroy(g_ivpci_class);
+}
+
+module_init(ivpci_init);
+module_exit(ivpci_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ivpci");
+MODULE_VERSION(DRV_VERSION);
-- 
2.32.0.3.g01195cf9f

