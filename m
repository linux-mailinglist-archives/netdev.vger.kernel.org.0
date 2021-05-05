Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B81F374989
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 22:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234987AbhEEUkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 16:40:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234675AbhEEUkC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 16:40:02 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37678613E3;
        Wed,  5 May 2021 20:39:04 +0000 (UTC)
Date:   Wed, 5 May 2021 16:38:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Joel Fernandes <joelaf@google.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [RFC][PATCH] vhost/vsock: Add vsock_list file to map cid with vhost
 tasks
Message-ID: <20210505163855.32dad8e7@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new trace-cmd 3.0 (which is almost ready to be released) allows for
tracing between host and guests with timestamp synchronization such that
the events on the host and the guest can be interleaved in the proper order
that they occur. KernelShark now has a plugin that visualizes this
interaction.

The implementation requires that the guest has a vsock CID assigned, and on
the guest a "trace-cmd agent" is running, that will listen on a port for
the CID. The on the host a "trace-cmd record -A guest@cid:port -e events"
can be called and the host will connect to the guest agent through the
cid/port pair and have the agent enable tracing on behalf of the host and
send the trace data back down to it.

The problem is that there is no sure fire way to find the CID for a guest.
Currently, the user must know the cid, or we have a hack that looks for the
qemu process and parses the --guest-cid parameter from it. But this is
prone to error and does not work on other implementation (was told that
crosvm does not use qemu).

As I can not find a way to discover CIDs assigned to guests via any kernel
interface, I decided to create this one. Note, I'm not attached to it. If
there's a better way to do this, I would love to have it. But since I'm not
an expert in the networking layer nor virtio, I decided to stick to what I
know and add a debugfs interface that simply lists all the registered CIDs
and the worker task that they are associated with. The worker task at
least has the PID of the task it represents.

Now I can find the cid / host process in charge of the guest pair:

  # cat /sys/kernel/debug/vsock_list
  3	vhost-1954:2002

  # ps aux | grep 1954
  qemu        1954  9.9 21.3 1629092 796148 ?      Sl   16:22   0:58  /usr/bin/qemu-kvm -name guest=Fedora21,debug-threads=on -S -object secret,id=masterKey0,format=raw,file=/var/lib/libvirt/qemu/domain-1-Fedora21/master-key.aes -machine pc-1.2,accel=kvm,usb=off,dump-guest-core=off -cpu qemu64 -m 1000 -overcommit mem-lock=off -smp 2,sockets=2,cores=1,threads=1 -uuid 1eefeeb0-3ac7-07c1-926e-236908313b4c -no-user-config -nodefaults -chardev socket,id=charmonitor,fd=32,server,nowait -mon chardev=charmonitor,id=monitor,mode=control -rtc base=utc -no-shutdown -boot strict=on -device piix3-usb-uhci,id=usb,bus=pci.0,addr=0x1.0x2 -device virtio-serial-pci,id=virtio-serial0,bus=pci.0,addr=0x6 -blockdev {"driver":"host_device","filename":"/dev/mapper/vg_bxtest-GuestFedora","node-name":"libvirt-1-storage","auto-read-only":true,"discard":"unmap"} -blockdev {"node-name":"libvirt-1-format","read-only":false,"driver":"raw","file":"libvirt-1-storage"} -device ide-hd,bus=ide.0,unit=0,drive=libvirt-1-
 format,id=ide0-0-0,bootindex=1 -netdev tap,fd=34,id=hostnet0 -device rtl8139,netdev=hostnet0,id=net0,mac=52:54:00:9f:e9:d5,bus=pci.0,addr=0x3 -netdev tap,fd=35,id=hostnet1 -device virtio-net-pci,netdev=hostnet1,id=net1,mac=52:54:00:ec:dc:6e,bus=pci.0,addr=0x5 -chardev pty,id=charserial0 -device isa-serial,chardev=charserial0,id=serial0 -chardev pipe,id=charchannel0,path=/var/lib/trace-cmd/virt/Fedora21/trace-pipe-cpu0 -device virtserialport,bus=virtio-serial0.0,nr=1,chardev=charchannel0,id=channel0,name=trace-pipe-cpu0 -chardev pipe,id=charchannel1,path=/var/lib/trace-cmd/virt/Fedora21/trace-pipe-cpu1 -device virtserialport,bus=virtio-serial0.0,nr=2,chardev=charchannel1,id=channel1,name=trace-pipe-cpu1 -vnc 127.0.0.1:0 -device cirrus-vga,id=video0,bus=pci.0,addr=0x2 -device virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x4 -sandbox on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny -device vhost-vsock-pci,id=vsock0,guest-cid=3,vhostfd=16,bus=pci.0,addr=0x7 -msg 
 timestamp=on
  root        2000  0.0  0.0      0     0 ?        S    16:22   0:00 [kvm-pit/1954]
  root        2002  0.0  0.0      0     0 ?        S    16:22   0:00 [vhost-1954]


This is just an example of what I'm looking for. Just a way to find what
process is using what cid.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 5e78fb719602..4f03b25b23c1 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -15,6 +15,7 @@
 #include <linux/virtio_vsock.h>
 #include <linux/vhost.h>
 #include <linux/hashtable.h>
+#include <linux/debugfs.h>
 
 #include <net/af_vsock.h>
 #include "vhost.h"
@@ -900,6 +901,128 @@ static struct miscdevice vhost_vsock_misc = {
 	.fops = &vhost_vsock_fops,
 };
 
+static struct dentry *vsock_file;
+
+struct vsock_file_iter {
+	struct hlist_node	*node;
+	int			index;
+};
+
+
+static void *vsock_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct vsock_file_iter *iter = v;
+	struct vhost_vsock *vsock;
+
+	if (pos)
+		(*pos)++;
+
+	if (iter->index >= (int)HASH_SIZE(vhost_vsock_hash))
+		return NULL;
+
+	if (iter->node)
+		iter->node = rcu_dereference_raw(hlist_next_rcu(iter->node));
+
+	for (;;) {
+		if (iter->node) {
+			vsock = hlist_entry_safe(rcu_dereference_raw(iter->node),
+						 struct vhost_vsock, hash);
+			if (vsock->guest_cid)
+				break;
+			iter->node = rcu_dereference_raw(hlist_next_rcu(iter->node));
+			continue;
+		}
+		iter->index++;
+		if (iter->index >= HASH_SIZE(vhost_vsock_hash))
+			return NULL;
+
+		iter->node = rcu_dereference_raw(hlist_first_rcu(&vhost_vsock_hash[iter->index]));
+	}
+	return iter;
+}
+
+static void *vsock_start(struct seq_file *m, loff_t *pos)
+{
+	struct vsock_file_iter *iter = m->private;
+	loff_t l = 0;
+	void *t;
+
+	rcu_read_lock();
+
+	iter->index = -1;
+	iter->node = NULL;
+	t = vsock_next(m, iter, NULL);
+
+	for (; iter->index < HASH_SIZE(vhost_vsock_hash) && l < *pos;
+	     t = vsock_next(m, iter, &l))
+		;
+
+	return t;
+}
+
+static void vsock_stop(struct seq_file *m, void *p)
+{
+	rcu_read_unlock();
+}
+
+static int vsock_show(struct seq_file *m, void *v)
+{
+	struct vsock_file_iter *iter = v;
+	struct vhost_vsock *vsock;
+	struct task_struct *worker;
+
+	if (!iter || iter->index >= HASH_SIZE(vhost_vsock_hash))
+		return 0;
+
+	vsock = hlist_entry_safe(rcu_dereference_raw(iter->node), struct vhost_vsock, hash);
+	worker = vsock->dev.worker;
+	seq_printf(m, "%d\t", vsock->guest_cid);
+
+	if (worker)
+		seq_printf(m, "%s:%d\n", worker->comm, worker->pid);
+	else
+		seq_puts(m, "(no task)\n");
+
+	return 0;
+}
+
+static const struct seq_operations vsock_file_seq_ops = {
+	.start		= vsock_start,
+	.next		= vsock_next,
+	.stop		= vsock_stop,
+	.show		= vsock_show,
+};
+
+static int vsock_file_open(struct inode *inode, struct file *file)
+{
+	struct vsock_file_iter *iter;
+	struct seq_file *m;
+	int ret;
+
+	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+	if (!iter)
+		return -ENOMEM;
+
+	ret = seq_open(file, &vsock_file_seq_ops);
+	if (ret) {
+		kfree(iter);
+		return ret;
+	}
+
+	m = file->private_data;
+	m->private = iter;
+
+	return 0;
+}
+
+static const struct file_operations vsock_file_fops = {
+	.owner		= THIS_MODULE,
+	.open		= vsock_file_open,
+	.release	= seq_release_private,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+
 static int __init vhost_vsock_init(void)
 {
 	int ret;
@@ -908,12 +1031,15 @@ static int __init vhost_vsock_init(void)
 				  VSOCK_TRANSPORT_F_H2G);
 	if (ret < 0)
 		return ret;
+	vsock_file = debugfs_create_file("vsock_list", 0400,
+					 NULL, NULL, &vsock_file_fops);
 	return misc_register(&vhost_vsock_misc);
 };
 
 static void __exit vhost_vsock_exit(void)
 {
 	misc_deregister(&vhost_vsock_misc);
+	debugfs_remove(vsock_file);
 	vsock_core_unregister(&vhost_transport.transport);
 };
 
