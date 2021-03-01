Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3F932780B
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 08:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbhCAHHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 02:07:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:51742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232265AbhCAHFS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 02:05:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B69BF64E38;
        Mon,  1 Mar 2021 07:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614582267;
        bh=+gTcpCfcvF1CAVoLP0ReNYyPiiq4BRV7ZA1s9DS5pqo=;
        h=From:To:Cc:Subject:Date:From;
        b=g2tt0ys99SiBYPlLe9kKmDLtDfoEZEweXY4+5FM4fodDVUhUrqmvxaXd8qpvpKCH8
         NCOB4lmyqTguCzG6Ug4+Rvqvj2eBl0Cemw3JTkdPBfVdQZiyOWVbblEIX+Ys+hrddc
         J0P3mdgPAp5UHNWfw4u72QhRpIZAjTdsl+5VTKkDA9omYmSuwAorPiz//zecNOBL60
         U7pH6zTWPNiZU3LxVq4sjaSJ5Olt57r0o6r5/Y5zrTzonTcXjKj7hZutA+AvmPlb0o
         HoGwfwSTqDsheTl5fvjuI2yCGKjAUkNYGDwz1mOJSitD9VjZMV39ZcmvYkXvzptPTO
         8vN6e2F4M+Lew==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Mark Bloch <mbloch@nvidia.com>, Adit Ranadive <aditr@vmware.com>,
        Ariel Elior <aelior@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Christian Benvenuti <benve@cisco.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lijun Ou <oulijun@huawei.com>, linux-rdma@vger.kernel.org,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        target-devel@vger.kernel.org,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        "Wei Hu(Xavier)" <huwei87@hisilicon.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH rdma-next] RDMA: Support more than 255 rdma ports
Date:   Mon,  1 Mar 2021 09:04:20 +0200
Message-Id: <20210301070420.439400-1-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Current code uses many different types when dealing with a port of a
RDMA device: u8, unsigned int and u32. Switch to u32 to clean up the
logic.

This allows us to make (at least) the core view consistent and use the same
type. Unfortunately not all places can be converted. Many uverbs functions
expect port to be u8 so keep those places in order not to break UAPIs.
HW/Spec defined values must also not be changed.

With the switch to u32 we now can support devices with more than 255
ports. U32_MAX is reserved to make control logic a bit easier to deal
with. As a device with U32_MAX ports probably isn't going to happen any
time soon this seems like a non issue.

When a device with more than 255 ports is created uverbs will report
the RDMA device as having 255 ports as this is the max currently supported.

The verbs interface is not changed yet because the IBTA spec limits the
port size in too many places to be u8 and all applications that relies in
verbs won't be able to cope with this change. At this stage, we are
extending the interfaces that are using vendor channel solely

Once the limitation is lifted mlx5 in switchdev mode will be able to have
thousands of SFs created by the device. As the only instance of an RDMA
device that reports more than 255 ports will be a representor device
and it exposes itself as a RAW Ethernet only device CM/MAD/IPoIB and other
ULPs aren't effected by this change and their sysfs/interfaces that
are exposes to userspace can remain unchanged.

While here cleanup some alignment issues and remove unneeded sanity
checks (mainly in rdmavt),

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/cache.c               |  84 ++++-----
 drivers/infiniband/core/cm.c                  |  12 +-
 drivers/infiniband/core/cma.c                 |  20 +-
 drivers/infiniband/core/cma_configfs.c        |   8 +-
 drivers/infiniband/core/cma_priv.h            |   8 +-
 drivers/infiniband/core/core_priv.h           |  28 +--
 drivers/infiniband/core/counters.c            |  20 +-
 drivers/infiniband/core/device.c              |  36 ++--
 drivers/infiniband/core/mad.c                 |  32 ++--
 drivers/infiniband/core/multicast.c           |   8 +-
 drivers/infiniband/core/nldev.c               |   2 +-
 drivers/infiniband/core/opa_smi.h             |   4 +-
 drivers/infiniband/core/roce_gid_mgmt.c       |  52 ++---
 drivers/infiniband/core/rw.c                  |  25 +--
 drivers/infiniband/core/sa.h                  |   2 +-
 drivers/infiniband/core/sa_query.c            |  22 +--
 drivers/infiniband/core/security.c            |   8 +-
 drivers/infiniband/core/smi.c                 |  12 +-
 drivers/infiniband/core/smi.h                 |   4 +-
 drivers/infiniband/core/sysfs.c               |  16 +-
 drivers/infiniband/core/user_mad.c            |   4 +-
 drivers/infiniband/core/uverbs_cmd.c          |   2 +-
 drivers/infiniband/core/verbs.c               |  29 +--
 drivers/infiniband/hw/bnxt_re/hw_counters.c   |   4 +-
 drivers/infiniband/hw/bnxt_re/hw_counters.h   |   4 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c      |  10 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.h      |  10 +-
 drivers/infiniband/hw/cxgb4/provider.c        |  12 +-
 drivers/infiniband/hw/efa/efa.h               |  14 +-
 drivers/infiniband/hw/efa/efa_verbs.c         |  14 +-
 drivers/infiniband/hw/hfi1/hfi.h              |  10 +-
 drivers/infiniband/hw/hfi1/init.c             |   2 +-
 drivers/infiniband/hw/hfi1/ipoib.h            |   2 +-
 drivers/infiniband/hw/hfi1/ipoib_main.c       |   4 +-
 drivers/infiniband/hw/hfi1/mad.c              | 128 ++++++-------
 drivers/infiniband/hw/hfi1/mad.h              |   2 +-
 drivers/infiniband/hw/hfi1/sysfs.c            |   2 +-
 drivers/infiniband/hw/hfi1/verbs.c            |   8 +-
 drivers/infiniband/hw/hfi1/verbs.h            |   4 +-
 drivers/infiniband/hw/hfi1/vnic.h             |   2 +-
 drivers/infiniband/hw/hfi1/vnic_main.c        |   2 +-
 drivers/infiniband/hw/hns/hns_roce_device.h   |   4 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c    |  10 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c    |   4 +-
 drivers/infiniband/hw/hns/hns_roce_main.c     |  20 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c     |  10 +-
 drivers/infiniband/hw/mlx4/alias_GUID.c       |  16 +-
 drivers/infiniband/hw/mlx4/mad.c              |  46 ++---
 drivers/infiniband/hw/mlx4/main.c             |  47 ++---
 drivers/infiniband/hw/mlx4/mlx4_ib.h          |  26 +--
 drivers/infiniband/hw/mlx5/cong.c             |   8 +-
 drivers/infiniband/hw/mlx5/counters.c         |  10 +-
 drivers/infiniband/hw/mlx5/counters.h         |   2 +-
 drivers/infiniband/hw/mlx5/ib_rep.c           |   4 +-
 drivers/infiniband/hw/mlx5/ib_rep.h           |   4 +-
 drivers/infiniband/hw/mlx5/ib_virt.c          |  16 +-
 drivers/infiniband/hw/mlx5/mad.c              |  16 +-
 drivers/infiniband/hw/mlx5/main.c             |  83 ++++----
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  40 ++--
 drivers/infiniband/hw/mlx5/qp.c               |   2 +-
 drivers/infiniband/hw/mthca/mthca_av.c        |   6 +-
 drivers/infiniband/hw/mthca/mthca_dev.h       |   8 +-
 drivers/infiniband/hw/mthca/mthca_mad.c       |   4 +-
 drivers/infiniband/hw/mthca/mthca_provider.c  |  10 +-
 drivers/infiniband/hw/mthca/mthca_qp.c        |   2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c      |   2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h      |   2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c    |   4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c   |   4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h   |   7 +-
 drivers/infiniband/hw/qedr/main.c             |   8 +-
 drivers/infiniband/hw/qedr/verbs.c            |   9 +-
 drivers/infiniband/hw/qedr/verbs.h            |  11 +-
 drivers/infiniband/hw/qib/qib.h               |   8 +-
 drivers/infiniband/hw/qib/qib_mad.c           |   4 +-
 drivers/infiniband/hw/qib/qib_qp.c            |   4 +-
 drivers/infiniband/hw/qib/qib_sysfs.c         |   2 +-
 drivers/infiniband/hw/qib/qib_verbs.c         |   6 +-
 drivers/infiniband/hw/qib/qib_verbs.h         |   6 +-
 drivers/infiniband/hw/usnic/usnic_ib_main.c   |   2 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c  |   6 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h  |   6 +-
 .../infiniband/hw/vmw_pvrdma/pvrdma_main.c    |   2 +-
 .../infiniband/hw/vmw_pvrdma/pvrdma_verbs.c   |  12 +-
 .../infiniband/hw/vmw_pvrdma/pvrdma_verbs.h   |  10 +-
 drivers/infiniband/sw/rdmavt/mad.c            |   5 +-
 drivers/infiniband/sw/rdmavt/mad.h            |   2 +-
 drivers/infiniband/sw/rdmavt/vt.c             |  34 +---
 drivers/infiniband/sw/rdmavt/vt.h             |  11 +-
 drivers/infiniband/sw/rxe/rxe_hw_counters.c   |   4 +-
 drivers/infiniband/sw/rxe/rxe_hw_counters.h   |   4 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c         |  10 +-
 drivers/infiniband/sw/siw/siw_verbs.c         |   8 +-
 drivers/infiniband/sw/siw/siw_verbs.h         |  10 +-
 drivers/infiniband/ulp/ipoib/ipoib.h          |   4 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c       |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |  14 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c         |   3 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |   2 +-
 include/rdma/ib_cache.h                       |  18 +-
 include/rdma/ib_mad.h                         |   2 +-
 include/rdma/ib_sa.h                          |  15 +-
 include/rdma/ib_verbs.h                       | 177 ++++++++++--------
 include/rdma/rdma_cm.h                        |   2 +-
 include/rdma/rdma_counter.h                   |  16 +-
 include/rdma/rdma_vt.h                        |   8 +-
 include/rdma/rw.h                             |  18 +-
 107 files changed, 777 insertions(+), 777 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 5c9fac7cf420..d77959089c38 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -121,7 +121,7 @@ struct ib_gid_table {
 	u32				default_gid_indices;
 };

-static void dispatch_gid_change_event(struct ib_device *ib_dev, u8 port)
+static void dispatch_gid_change_event(struct ib_device *ib_dev, u32 port)
 {
 	struct ib_event event;

@@ -197,7 +197,7 @@ int ib_cache_gid_parse_type_str(const char *buf)
 }
 EXPORT_SYMBOL(ib_cache_gid_parse_type_str);

-static struct ib_gid_table *rdma_gid_table(struct ib_device *device, u8 port)
+static struct ib_gid_table *rdma_gid_table(struct ib_device *device, u32 port)
 {
 	return device->port_data[port].cache.gid;
 }
@@ -237,10 +237,10 @@ static void put_gid_ndev(struct rcu_head *head)
 static void free_gid_entry_locked(struct ib_gid_table_entry *entry)
 {
 	struct ib_device *device = entry->attr.device;
-	u8 port_num = entry->attr.port_num;
+	u32 port_num = entry->attr.port_num;
 	struct ib_gid_table *table = rdma_gid_table(device, port_num);

-	dev_dbg(&device->dev, "%s port=%d index=%d gid %pI6\n", __func__,
+	dev_dbg(&device->dev, "%s port=%u index=%d gid %pI6\n", __func__,
 		port_num, entry->attr.index, entry->attr.gid.raw);

 	write_lock_irq(&table->rwlock);
@@ -282,7 +282,7 @@ static void free_gid_work(struct work_struct *work)
 	struct ib_gid_table_entry *entry =
 		container_of(work, struct ib_gid_table_entry, del_work);
 	struct ib_device *device = entry->attr.device;
-	u8 port_num = entry->attr.port_num;
+	u32 port_num = entry->attr.port_num;
 	struct ib_gid_table *table = rdma_gid_table(device, port_num);

 	mutex_lock(&table->lock);
@@ -379,7 +379,7 @@ static int add_roce_gid(struct ib_gid_table_entry *entry)
  * @ix:		GID entry index to delete
  *
  */
-static void del_gid(struct ib_device *ib_dev, u8 port,
+static void del_gid(struct ib_device *ib_dev, u32 port,
 		    struct ib_gid_table *table, int ix)
 {
 	struct roce_gid_ndev_storage *ndev_storage;
@@ -387,7 +387,7 @@ static void del_gid(struct ib_device *ib_dev, u8 port,

 	lockdep_assert_held(&table->lock);

-	dev_dbg(&ib_dev->dev, "%s port=%d index=%d gid %pI6\n", __func__, port,
+	dev_dbg(&ib_dev->dev, "%s port=%u index=%d gid %pI6\n", __func__, port,
 		ix, table->data_vec[ix]->attr.gid.raw);

 	write_lock_irq(&table->rwlock);
@@ -543,7 +543,7 @@ static void make_default_gid(struct  net_device *dev, union ib_gid *gid)
 	addrconf_ifid_eui48(&gid->raw[8], dev);
 }

-static int __ib_cache_gid_add(struct ib_device *ib_dev, u8 port,
+static int __ib_cache_gid_add(struct ib_device *ib_dev, u32 port,
 			      union ib_gid *gid, struct ib_gid_attr *attr,
 			      unsigned long mask, bool default_gid)
 {
@@ -587,7 +587,7 @@ static int __ib_cache_gid_add(struct ib_device *ib_dev, u8 port,
 	return ret;
 }

-int ib_cache_gid_add(struct ib_device *ib_dev, u8 port,
+int ib_cache_gid_add(struct ib_device *ib_dev, u32 port,
 		     union ib_gid *gid, struct ib_gid_attr *attr)
 {
 	unsigned long mask = GID_ATTR_FIND_MASK_GID |
@@ -598,7 +598,7 @@ int ib_cache_gid_add(struct ib_device *ib_dev, u8 port,
 }

 static int
-_ib_cache_gid_del(struct ib_device *ib_dev, u8 port,
+_ib_cache_gid_del(struct ib_device *ib_dev, u32 port,
 		  union ib_gid *gid, struct ib_gid_attr *attr,
 		  unsigned long mask, bool default_gid)
 {
@@ -627,7 +627,7 @@ _ib_cache_gid_del(struct ib_device *ib_dev, u8 port,
 	return ret;
 }

-int ib_cache_gid_del(struct ib_device *ib_dev, u8 port,
+int ib_cache_gid_del(struct ib_device *ib_dev, u32 port,
 		     union ib_gid *gid, struct ib_gid_attr *attr)
 {
 	unsigned long mask = GID_ATTR_FIND_MASK_GID	  |
@@ -638,7 +638,7 @@ int ib_cache_gid_del(struct ib_device *ib_dev, u8 port,
 	return _ib_cache_gid_del(ib_dev, port, gid, attr, mask, false);
 }

-int ib_cache_gid_del_all_netdev_gids(struct ib_device *ib_dev, u8 port,
+int ib_cache_gid_del_all_netdev_gids(struct ib_device *ib_dev, u32 port,
 				     struct net_device *ndev)
 {
 	struct ib_gid_table *table;
@@ -683,7 +683,7 @@ const struct ib_gid_attr *
 rdma_find_gid_by_port(struct ib_device *ib_dev,
 		      const union ib_gid *gid,
 		      enum ib_gid_type gid_type,
-		      u8 port, struct net_device *ndev)
+		      u32 port, struct net_device *ndev)
 {
 	int local_index;
 	struct ib_gid_table *table;
@@ -734,7 +734,7 @@ EXPORT_SYMBOL(rdma_find_gid_by_port);
  *
  */
 const struct ib_gid_attr *rdma_find_gid_by_filter(
-	struct ib_device *ib_dev, const union ib_gid *gid, u8 port,
+	struct ib_device *ib_dev, const union ib_gid *gid, u32 port,
 	bool (*filter)(const union ib_gid *gid, const struct ib_gid_attr *,
 		       void *),
 	void *context)
@@ -818,7 +818,7 @@ static void release_gid_table(struct ib_device *device,
 	kfree(table);
 }

-static void cleanup_gid_table_port(struct ib_device *ib_dev, u8 port,
+static void cleanup_gid_table_port(struct ib_device *ib_dev, u32 port,
 				   struct ib_gid_table *table)
 {
 	int i;
@@ -834,7 +834,7 @@ static void cleanup_gid_table_port(struct ib_device *ib_dev, u8 port,
 	mutex_unlock(&table->lock);
 }

-void ib_cache_gid_set_default_gid(struct ib_device *ib_dev, u8 port,
+void ib_cache_gid_set_default_gid(struct ib_device *ib_dev, u32 port,
 				  struct net_device *ndev,
 				  unsigned long gid_type_mask,
 				  enum ib_cache_gid_default_mode mode)
@@ -867,7 +867,7 @@ void ib_cache_gid_set_default_gid(struct ib_device *ib_dev, u8 port,
 	}
 }

-static void gid_table_reserve_default(struct ib_device *ib_dev, u8 port,
+static void gid_table_reserve_default(struct ib_device *ib_dev, u32 port,
 				      struct ib_gid_table *table)
 {
 	unsigned int i;
@@ -884,7 +884,7 @@ static void gid_table_reserve_default(struct ib_device *ib_dev, u8 port,

 static void gid_table_release_one(struct ib_device *ib_dev)
 {
-	unsigned int p;
+	u32 p;

 	rdma_for_each_port (ib_dev, p) {
 		release_gid_table(ib_dev, ib_dev->port_data[p].cache.gid);
@@ -895,7 +895,7 @@ static void gid_table_release_one(struct ib_device *ib_dev)
 static int _gid_table_setup_one(struct ib_device *ib_dev)
 {
 	struct ib_gid_table *table;
-	unsigned int rdma_port;
+	u32 rdma_port;

 	rdma_for_each_port (ib_dev, rdma_port) {
 		table = alloc_gid_table(
@@ -915,7 +915,7 @@ static int _gid_table_setup_one(struct ib_device *ib_dev)

 static void gid_table_cleanup_one(struct ib_device *ib_dev)
 {
-	unsigned int p;
+	u32 p;

 	rdma_for_each_port (ib_dev, p)
 		cleanup_gid_table_port(ib_dev, p,
@@ -950,7 +950,7 @@ static int gid_table_setup_one(struct ib_device *ib_dev)
  * Returns 0 on success or appropriate error code.
  *
  */
-int rdma_query_gid(struct ib_device *device, u8 port_num,
+int rdma_query_gid(struct ib_device *device, u32 port_num,
 		   int index, union ib_gid *gid)
 {
 	struct ib_gid_table *table;
@@ -1014,7 +1014,7 @@ const struct ib_gid_attr *rdma_find_gid(struct ib_device *device,
 	unsigned long mask = GID_ATTR_FIND_MASK_GID |
 			     GID_ATTR_FIND_MASK_GID_TYPE;
 	struct ib_gid_attr gid_attr_val = {.ndev = ndev, .gid_type = gid_type};
-	unsigned int p;
+	u32 p;

 	if (ndev)
 		mask |= GID_ATTR_FIND_MASK_NETDEV;
@@ -1043,7 +1043,7 @@ const struct ib_gid_attr *rdma_find_gid(struct ib_device *device,
 EXPORT_SYMBOL(rdma_find_gid);

 int ib_get_cached_pkey(struct ib_device *device,
-		       u8                port_num,
+		       u32               port_num,
 		       int               index,
 		       u16              *pkey)
 {
@@ -1069,9 +1069,8 @@ int ib_get_cached_pkey(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_get_cached_pkey);

-int ib_get_cached_subnet_prefix(struct ib_device *device,
-				u8                port_num,
-				u64              *sn_pfx)
+int ib_get_cached_subnet_prefix(struct ib_device *device, u32 port_num,
+				u64 *sn_pfx)
 {
 	unsigned long flags;

@@ -1086,10 +1085,8 @@ int ib_get_cached_subnet_prefix(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_get_cached_subnet_prefix);

-int ib_find_cached_pkey(struct ib_device *device,
-			u8                port_num,
-			u16               pkey,
-			u16              *index)
+int ib_find_cached_pkey(struct ib_device *device, u32 port_num,
+			u16 pkey, u16 *index)
 {
 	struct ib_pkey_cache *cache;
 	unsigned long flags;
@@ -1132,10 +1129,8 @@ int ib_find_cached_pkey(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_find_cached_pkey);

-int ib_find_exact_cached_pkey(struct ib_device *device,
-			      u8                port_num,
-			      u16               pkey,
-			      u16              *index)
+int ib_find_exact_cached_pkey(struct ib_device *device, u32 port_num,
+			      u16 pkey, u16 *index)
 {
 	struct ib_pkey_cache *cache;
 	unsigned long flags;
@@ -1169,9 +1164,7 @@ int ib_find_exact_cached_pkey(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_find_exact_cached_pkey);

-int ib_get_cached_lmc(struct ib_device *device,
-		      u8                port_num,
-		      u8                *lmc)
+int ib_get_cached_lmc(struct ib_device *device, u32 port_num, u8 *lmc)
 {
 	unsigned long flags;
 	int ret = 0;
@@ -1187,8 +1180,7 @@ int ib_get_cached_lmc(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_get_cached_lmc);

-int ib_get_cached_port_state(struct ib_device   *device,
-			     u8                  port_num,
+int ib_get_cached_port_state(struct ib_device *device, u32 port_num,
 			     enum ib_port_state *port_state)
 {
 	unsigned long flags;
@@ -1222,7 +1214,7 @@ EXPORT_SYMBOL(ib_get_cached_port_state);
  * code.
  */
 const struct ib_gid_attr *
-rdma_get_gid_attr(struct ib_device *device, u8 port_num, int index)
+rdma_get_gid_attr(struct ib_device *device, u32 port_num, int index)
 {
 	const struct ib_gid_attr *attr = ERR_PTR(-ENODATA);
 	struct ib_gid_table *table;
@@ -1263,7 +1255,7 @@ ssize_t rdma_query_gid_table(struct ib_device *device,
 	const struct ib_gid_attr *gid_attr;
 	ssize_t num_entries = 0, ret;
 	struct ib_gid_table *table;
-	unsigned int port_num, i;
+	u32 port_num, i;
 	struct net_device *ndev;
 	unsigned long flags;

@@ -1361,7 +1353,7 @@ struct net_device *rdma_read_gid_attr_ndev_rcu(const struct ib_gid_attr *attr)
 			container_of(attr, struct ib_gid_table_entry, attr);
 	struct ib_device *device = entry->attr.device;
 	struct net_device *ndev = ERR_PTR(-EINVAL);
-	u8 port_num = entry->attr.port_num;
+	u32 port_num = entry->attr.port_num;
 	struct ib_gid_table *table;
 	unsigned long flags;
 	bool valid;
@@ -1441,7 +1433,7 @@ int rdma_read_gid_l2_fields(const struct ib_gid_attr *attr,
 EXPORT_SYMBOL(rdma_read_gid_l2_fields);

 static int config_non_roce_gid_cache(struct ib_device *device,
-				     u8 port, int gid_tbl_len)
+				     u32 port, int gid_tbl_len)
 {
 	struct ib_gid_attr gid_attr = {};
 	struct ib_gid_table *table;
@@ -1472,7 +1464,7 @@ static int config_non_roce_gid_cache(struct ib_device *device,
 }

 static int
-ib_cache_update(struct ib_device *device, u8 port, bool enforce_security)
+ib_cache_update(struct ib_device *device, u32 port, bool enforce_security)
 {
 	struct ib_port_attr       *tprops = NULL;
 	struct ib_pkey_cache      *pkey_cache = NULL, *old_pkey_cache;
@@ -1621,7 +1613,7 @@ EXPORT_SYMBOL(ib_dispatch_event);

 int ib_cache_setup_one(struct ib_device *device)
 {
-	unsigned int p;
+	u32 p;
 	int err;

 	rwlock_init(&device->cache_lock);
@@ -1641,7 +1633,7 @@ int ib_cache_setup_one(struct ib_device *device)

 void ib_cache_release_one(struct ib_device *device)
 {
-	unsigned int p;
+	u32 p;

 	/*
 	 * The release function frees all the cache elements.
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index be996dba040c..c764880a34eb 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -202,7 +202,7 @@ static struct attribute *cm_counter_default_attrs[] = {
 struct cm_port {
 	struct cm_device *cm_dev;
 	struct ib_mad_agent *mad_agent;
-	u8 port_num;
+	u32 port_num;
 	struct list_head cm_priv_prim_list;
 	struct list_head cm_priv_altr_list;
 	struct cm_counter_group counter_group[CM_COUNTER_GROUPS];
@@ -1631,7 +1631,7 @@ static bool cm_req_has_alt_path(struct cm_req_msg *req_msg)
 					       req_msg))));
 }

-static void cm_path_set_rec_type(struct ib_device *ib_device, u8 port_num,
+static void cm_path_set_rec_type(struct ib_device *ib_device, u32 port_num,
 				 struct sa_path_rec *path, union ib_gid *gid)
 {
 	if (ib_is_opa_gid(gid) && rdma_cap_opa_ah(ib_device, port_num))
@@ -1750,7 +1750,7 @@ static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 static u16 cm_get_bth_pkey(struct cm_work *work)
 {
 	struct ib_device *ib_dev = work->port->cm_dev->ib_device;
-	u8 port_num = work->port->port_num;
+	u32 port_num = work->port->port_num;
 	u16 pkey_index = work->mad_recv_wc->wc->pkey_index;
 	u16 pkey;
 	int ret;
@@ -1778,7 +1778,7 @@ static void cm_opa_to_ib_sgid(struct cm_work *work,
 			      struct sa_path_rec *path)
 {
 	struct ib_device *dev = work->port->cm_dev->ib_device;
-	u8 port_num = work->port->port_num;
+	u32 port_num = work->port->port_num;

 	if (rdma_cap_opa_ah(dev, port_num) &&
 	    (ib_is_opa_gid(&path->sgid))) {
@@ -4333,7 +4333,7 @@ static int cm_add_one(struct ib_device *ib_device)
 	unsigned long flags;
 	int ret;
 	int count = 0;
-	unsigned int i;
+	u32 i;

 	cm_dev = kzalloc(struct_size(cm_dev, port, ib_device->phys_port_cnt),
 			 GFP_KERNEL);
@@ -4431,7 +4431,7 @@ static void cm_remove_one(struct ib_device *ib_device, void *client_data)
 		.clr_port_cap_mask = IB_PORT_CM_SUP
 	};
 	unsigned long flags;
-	unsigned int i;
+	u32 i;

 	write_lock_irqsave(&cm.device_lock, flags);
 	list_del(&cm_dev->list);
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 94096511599f..2a93fd32e0fe 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -224,7 +224,7 @@ struct class_port_info_context {
 	struct ib_device		*device;
 	struct completion		done;
 	struct ib_sa_query		*sa_query;
-	u8				port_num;
+	u32				port_num;
 };

 static int cma_ps_alloc(struct net *net, enum rdma_ucm_port_space ps,
@@ -287,7 +287,7 @@ struct cma_device *cma_enum_devices_by_ibdev(cma_device_filter	filter,
 }

 int cma_get_default_gid_type(struct cma_device *cma_dev,
-			     unsigned int port)
+			     u32 port)
 {
 	if (!rdma_is_port_valid(cma_dev->device, port))
 		return -EINVAL;
@@ -296,7 +296,7 @@ int cma_get_default_gid_type(struct cma_device *cma_dev,
 }

 int cma_set_default_gid_type(struct cma_device *cma_dev,
-			     unsigned int port,
+			     u32 port,
 			     enum ib_gid_type default_gid_type)
 {
 	unsigned long supported_gids;
@@ -319,7 +319,7 @@ int cma_set_default_gid_type(struct cma_device *cma_dev,
 	return 0;
 }

-int cma_get_default_roce_tos(struct cma_device *cma_dev, unsigned int port)
+int cma_get_default_roce_tos(struct cma_device *cma_dev, u32 port)
 {
 	if (!rdma_is_port_valid(cma_dev->device, port))
 		return -EINVAL;
@@ -327,7 +327,7 @@ int cma_get_default_roce_tos(struct cma_device *cma_dev, unsigned int port)
 	return cma_dev->default_roce_tos[port - rdma_start_port(cma_dev->device)];
 }

-int cma_set_default_roce_tos(struct cma_device *cma_dev, unsigned int port,
+int cma_set_default_roce_tos(struct cma_device *cma_dev, u32 port,
 			     u8 default_roce_tos)
 {
 	if (!rdma_is_port_valid(cma_dev->device, port))
@@ -562,7 +562,7 @@ static int cma_translate_addr(struct sockaddr *addr, struct rdma_dev_addr *dev_a
 }

 static const struct ib_gid_attr *
-cma_validate_port(struct ib_device *device, u8 port,
+cma_validate_port(struct ib_device *device, u32 port,
 		  enum ib_gid_type gid_type,
 		  union ib_gid *gid,
 		  struct rdma_id_private *id_priv)
@@ -620,7 +620,7 @@ static int cma_acquire_dev_by_src_ip(struct rdma_id_private *id_priv)
 	struct cma_device *cma_dev;
 	enum ib_gid_type gid_type;
 	int ret = -ENODEV;
-	unsigned int port;
+	u32 port;

 	if (dev_addr->dev_type != ARPHRD_INFINIBAND &&
 	    id_priv->id.ps == RDMA_PS_IPOIB)
@@ -711,8 +711,8 @@ static int cma_iw_acquire_dev(struct rdma_id_private *id_priv,
 	struct cma_device *cma_dev;
 	enum ib_gid_type gid_type;
 	int ret = -ENODEV;
-	unsigned int port;
 	union ib_gid gid;
+	u32 port;

 	if (dev_addr->dev_type != ARPHRD_INFINIBAND &&
 	    id_priv->id.ps == RDMA_PS_IPOIB)
@@ -1581,7 +1581,7 @@ static bool cma_match_private_data(struct rdma_id_private *id_priv,
 static bool cma_protocol_roce(const struct rdma_cm_id *id)
 {
 	struct ib_device *device = id->device;
-	const int port_num = id->port_num ?: rdma_start_port(device);
+	const u32 port_num = id->port_num ?: rdma_start_port(device);

 	return rdma_protocol_roce(device, port_num);
 }
@@ -4869,9 +4869,9 @@ static int cma_add_one(struct ib_device *device)
 	struct rdma_id_private *to_destroy;
 	struct cma_device *cma_dev;
 	struct rdma_id_private *id_priv;
-	unsigned int i;
 	unsigned long supported_gids = 0;
 	int ret;
+	u32 i;

 	cma_dev = kmalloc(sizeof(*cma_dev), GFP_KERNEL);
 	if (!cma_dev)
diff --git a/drivers/infiniband/core/cma_configfs.c b/drivers/infiniband/core/cma_configfs.c
index e0d5e3bae458..9ac16e0db761 100644
--- a/drivers/infiniband/core/cma_configfs.c
+++ b/drivers/infiniband/core/cma_configfs.c
@@ -43,7 +43,7 @@ struct cma_device;
 struct cma_dev_group;

 struct cma_dev_port_group {
-	unsigned int		port_num;
+	u32			port_num;
 	struct cma_dev_group	*cma_dev_group;
 	struct config_group	group;
 };
@@ -200,10 +200,10 @@ static const struct config_item_type cma_port_group_type = {
 static int make_cma_ports(struct cma_dev_group *cma_dev_group,
 			  struct cma_device *cma_dev)
 {
-	struct ib_device *ibdev;
-	unsigned int i;
-	unsigned int ports_num;
 	struct cma_dev_port_group *ports;
+	struct ib_device *ibdev;
+	u32 ports_num;
+	u32 i;

 	ibdev = cma_get_ib_dev(cma_dev);

diff --git a/drivers/infiniband/core/cma_priv.h b/drivers/infiniband/core/cma_priv.h
index caece96ebcf5..8af6af4bbf6e 100644
--- a/drivers/infiniband/core/cma_priv.h
+++ b/drivers/infiniband/core/cma_priv.h
@@ -117,11 +117,11 @@ void cma_dev_put(struct cma_device *dev);
 typedef bool (*cma_device_filter)(struct ib_device *, void *);
 struct cma_device *cma_enum_devices_by_ibdev(cma_device_filter filter,
 					     void *cookie);
-int cma_get_default_gid_type(struct cma_device *dev, unsigned int port);
-int cma_set_default_gid_type(struct cma_device *dev, unsigned int port,
+int cma_get_default_gid_type(struct cma_device *dev, u32 port);
+int cma_set_default_gid_type(struct cma_device *dev, u32 port,
 			     enum ib_gid_type default_gid_type);
-int cma_get_default_roce_tos(struct cma_device *dev, unsigned int port);
-int cma_set_default_roce_tos(struct cma_device *dev, unsigned int port,
+int cma_get_default_roce_tos(struct cma_device *dev, u32 port);
+int cma_set_default_roce_tos(struct cma_device *dev, u32 port,
 			     u8 default_roce_tos);
 struct ib_device *cma_get_ib_dev(struct cma_device *dev);

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 315f7a297eee..29809dd30041 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -83,14 +83,14 @@ void ib_device_unregister_sysfs(struct ib_device *device);
 int ib_device_rename(struct ib_device *ibdev, const char *name);
 int ib_device_set_dim(struct ib_device *ibdev, u8 use_dim);

-typedef void (*roce_netdev_callback)(struct ib_device *device, u8 port,
+typedef void (*roce_netdev_callback)(struct ib_device *device, u32 port,
 	      struct net_device *idev, void *cookie);

-typedef bool (*roce_netdev_filter)(struct ib_device *device, u8 port,
+typedef bool (*roce_netdev_filter)(struct ib_device *device, u32 port,
 				   struct net_device *idev, void *cookie);

 struct net_device *ib_device_get_netdev(struct ib_device *ib_dev,
-					unsigned int port);
+					u32 port);

 void ib_enum_roce_netdev(struct ib_device *ib_dev,
 			 roce_netdev_filter filter,
@@ -113,7 +113,7 @@ int ib_enum_all_devs(nldev_callback nldev_cb, struct sk_buff *skb,
 struct ib_client_nl_info {
 	struct sk_buff *nl_msg;
 	struct device *cdev;
-	unsigned int port;
+	u32 port;
 	u64 abi;
 };
 int ib_get_client_nl_info(struct ib_device *ibdev, const char *client_name,
@@ -128,24 +128,24 @@ int ib_cache_gid_parse_type_str(const char *buf);

 const char *ib_cache_gid_type_str(enum ib_gid_type gid_type);

-void ib_cache_gid_set_default_gid(struct ib_device *ib_dev, u8 port,
+void ib_cache_gid_set_default_gid(struct ib_device *ib_dev, u32 port,
 				  struct net_device *ndev,
 				  unsigned long gid_type_mask,
 				  enum ib_cache_gid_default_mode mode);

-int ib_cache_gid_add(struct ib_device *ib_dev, u8 port,
+int ib_cache_gid_add(struct ib_device *ib_dev, u32 port,
 		     union ib_gid *gid, struct ib_gid_attr *attr);

-int ib_cache_gid_del(struct ib_device *ib_dev, u8 port,
+int ib_cache_gid_del(struct ib_device *ib_dev, u32 port,
 		     union ib_gid *gid, struct ib_gid_attr *attr);

-int ib_cache_gid_del_all_netdev_gids(struct ib_device *ib_dev, u8 port,
+int ib_cache_gid_del_all_netdev_gids(struct ib_device *ib_dev, u32 port,
 				     struct net_device *ndev);

 int roce_gid_mgmt_init(void);
 void roce_gid_mgmt_cleanup(void);

-unsigned long roce_gid_type_mask_support(struct ib_device *ib_dev, u8 port);
+unsigned long roce_gid_type_mask_support(struct ib_device *ib_dev, u32 port);

 int ib_cache_setup_one(struct ib_device *device);
 void ib_cache_cleanup_one(struct ib_device *device);
@@ -215,14 +215,14 @@ int ib_nl_handle_ip_res_resp(struct sk_buff *skb,
 			     struct netlink_ext_ack *extack);

 int ib_get_cached_subnet_prefix(struct ib_device *device,
-				u8                port_num,
-				u64              *sn_pfx);
+				u32 port_num,
+				u64 *sn_pfx);

 #ifdef CONFIG_SECURITY_INFINIBAND
 void ib_security_release_port_pkey_list(struct ib_device *device);

 void ib_security_cache_change(struct ib_device *device,
-			      u8 port_num,
+			      u32 port_num,
 			      u64 subnet_prefix);

 int ib_security_modify_qp(struct ib_qp *qp,
@@ -247,7 +247,7 @@ static inline void ib_security_release_port_pkey_list(struct ib_device *device)
 }

 static inline void ib_security_cache_change(struct ib_device *device,
-					    u8 port_num,
+					    u32 port_num,
 					    u64 subnet_prefix)
 {
 }
@@ -381,7 +381,7 @@ int ib_setup_port_attrs(struct ib_core_device *coredev);

 int rdma_compatdev_set(u8 enable);

-int ib_port_register_module_stat(struct ib_device *device, u8 port_num,
+int ib_port_register_module_stat(struct ib_device *device, u32 port_num,
 				 struct kobject *kobj, struct kobj_type *ktype,
 				 const char *name);
 void ib_port_unregister_module_stat(struct kobject *kobj);
diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index f3a7c1f404af..a284a358de51 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -34,7 +34,7 @@ static int __counter_set_mode(struct rdma_port_counter *port_counter,
  *
  * Return 0 on success.
  */
-int rdma_counter_set_auto_mode(struct ib_device *dev, u8 port,
+int rdma_counter_set_auto_mode(struct ib_device *dev, u32 port,
 			       enum rdma_nl_counter_mask mask,
 			       struct netlink_ext_ack *extack)
 {
@@ -100,7 +100,7 @@ static int __rdma_counter_bind_qp(struct rdma_counter *counter,
 	return ret;
 }

-static struct rdma_counter *alloc_and_bind(struct ib_device *dev, u8 port,
+static struct rdma_counter *alloc_and_bind(struct ib_device *dev, u32 port,
 					   struct ib_qp *qp,
 					   enum rdma_nl_counter_mode mode)
 {
@@ -238,7 +238,7 @@ static void counter_history_stat_update(struct rdma_counter *counter)
  * Return: The counter (with ref-count increased) if found
  */
 static struct rdma_counter *rdma_get_counter_auto_mode(struct ib_qp *qp,
-						       u8 port)
+						       u32 port)
 {
 	struct rdma_port_counter *port_counter;
 	struct rdma_counter *counter = NULL;
@@ -282,7 +282,7 @@ static void counter_release(struct kref *kref)
  * rdma_counter_bind_qp_auto - Check and bind the QP to a counter base on
  *   the auto-mode rule
  */
-int rdma_counter_bind_qp_auto(struct ib_qp *qp, u8 port)
+int rdma_counter_bind_qp_auto(struct ib_qp *qp, u32 port)
 {
 	struct rdma_port_counter *port_counter;
 	struct ib_device *dev = qp->device;
@@ -352,7 +352,7 @@ int rdma_counter_query_stats(struct rdma_counter *counter)
 }

 static u64 get_running_counters_hwstat_sum(struct ib_device *dev,
-					   u8 port, u32 index)
+					   u32 port, u32 index)
 {
 	struct rdma_restrack_entry *res;
 	struct rdma_restrack_root *rt;
@@ -388,7 +388,7 @@ static u64 get_running_counters_hwstat_sum(struct ib_device *dev,
  * rdma_counter_get_hwstat_value() - Get the sum value of all counters on a
  *   specific port, including the running ones and history data
  */
-u64 rdma_counter_get_hwstat_value(struct ib_device *dev, u8 port, u32 index)
+u64 rdma_counter_get_hwstat_value(struct ib_device *dev, u32 port, u32 index)
 {
 	struct rdma_port_counter *port_counter;
 	u64 sum;
@@ -443,7 +443,7 @@ static struct rdma_counter *rdma_get_counter_by_id(struct ib_device *dev,
 /*
  * rdma_counter_bind_qpn() - Bind QP @qp_num to counter @counter_id
  */
-int rdma_counter_bind_qpn(struct ib_device *dev, u8 port,
+int rdma_counter_bind_qpn(struct ib_device *dev, u32 port,
 			  u32 qp_num, u32 counter_id)
 {
 	struct rdma_port_counter *port_counter;
@@ -493,7 +493,7 @@ int rdma_counter_bind_qpn(struct ib_device *dev, u8 port,
  * rdma_counter_bind_qpn_alloc() - Alloc a counter and bind QP @qp_num to it
  *   The id of new counter is returned in @counter_id
  */
-int rdma_counter_bind_qpn_alloc(struct ib_device *dev, u8 port,
+int rdma_counter_bind_qpn_alloc(struct ib_device *dev, u32 port,
 				u32 qp_num, u32 *counter_id)
 {
 	struct rdma_port_counter *port_counter;
@@ -540,7 +540,7 @@ int rdma_counter_bind_qpn_alloc(struct ib_device *dev, u8 port,
 /*
  * rdma_counter_unbind_qpn() - Unbind QP @qp_num from a counter
  */
-int rdma_counter_unbind_qpn(struct ib_device *dev, u8 port,
+int rdma_counter_unbind_qpn(struct ib_device *dev, u32 port,
 			    u32 qp_num, u32 counter_id)
 {
 	struct rdma_port_counter *port_counter;
@@ -573,7 +573,7 @@ int rdma_counter_unbind_qpn(struct ib_device *dev, u8 port,
 	return ret;
 }

-int rdma_counter_get_mode(struct ib_device *dev, u8 port,
+int rdma_counter_get_mode(struct ib_device *dev, u32 port,
 			  enum rdma_nl_counter_mode *mode,
 			  enum rdma_nl_counter_mask *mask)
 {
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index aac0fe14e1d9..9b3773a62cae 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -779,7 +779,7 @@ static void remove_client_context(struct ib_device *device,
 static int alloc_port_data(struct ib_device *device)
 {
 	struct ib_port_data_rcu *pdata_rcu;
-	unsigned int port;
+	u32 port;

 	if (device->port_data)
 		return 0;
@@ -788,6 +788,10 @@ static int alloc_port_data(struct ib_device *device)
 	if (WARN_ON(!device->phys_port_cnt))
 		return -EINVAL;

+	/* Reserve U32_MAX so the logic to go over all the ports is sane */
+	if (WARN_ON(device->phys_port_cnt == U32_MAX))
+		return -EINVAL;
+
 	/*
 	 * device->port_data is indexed directly by the port number to make
 	 * access to this data as efficient as possible.
@@ -819,7 +823,7 @@ static int alloc_port_data(struct ib_device *device)
 	return 0;
 }

-static int verify_immutable(const struct ib_device *dev, u8 port)
+static int verify_immutable(const struct ib_device *dev, u32 port)
 {
 	return WARN_ON(!rdma_cap_ib_mad(dev, port) &&
 			    rdma_max_mad_size(dev, port) != 0);
@@ -827,7 +831,7 @@ static int verify_immutable(const struct ib_device *dev, u8 port)

 static int setup_port_data(struct ib_device *device)
 {
-	unsigned int port;
+	u32 port;
 	int ret;

 	ret = alloc_port_data(device);
@@ -2005,7 +2009,7 @@ void ib_dispatch_event_clients(struct ib_event *event)
 }

 static int iw_query_port(struct ib_device *device,
-			   u8 port_num,
+			   u32 port_num,
 			   struct ib_port_attr *port_attr)
 {
 	struct in_device *inetdev;
@@ -2044,7 +2048,7 @@ static int iw_query_port(struct ib_device *device,
 }

 static int __ib_query_port(struct ib_device *device,
-			   u8 port_num,
+			   u32 port_num,
 			   struct ib_port_attr *port_attr)
 {
 	union ib_gid gid = {};
@@ -2078,7 +2082,7 @@ static int __ib_query_port(struct ib_device *device,
  * @port_attr pointer.
  */
 int ib_query_port(struct ib_device *device,
-		  u8 port_num,
+		  u32 port_num,
 		  struct ib_port_attr *port_attr)
 {
 	if (!rdma_is_port_valid(device, port_num))
@@ -2130,7 +2134,7 @@ static void add_ndev_hash(struct ib_port_data *pdata)
  * NETDEV_UNREGISTER event.
  */
 int ib_device_set_netdev(struct ib_device *ib_dev, struct net_device *ndev,
-			 unsigned int port)
+			 u32 port)
 {
 	struct net_device *old_ndev;
 	struct ib_port_data *pdata;
@@ -2173,7 +2177,7 @@ EXPORT_SYMBOL(ib_device_set_netdev);
 static void free_netdevs(struct ib_device *ib_dev)
 {
 	unsigned long flags;
-	unsigned int port;
+	u32 port;

 	if (!ib_dev->port_data)
 		return;
@@ -2204,7 +2208,7 @@ static void free_netdevs(struct ib_device *ib_dev)
 }

 struct net_device *ib_device_get_netdev(struct ib_device *ib_dev,
-					unsigned int port)
+					u32 port)
 {
 	struct ib_port_data *pdata;
 	struct net_device *res;
@@ -2291,7 +2295,7 @@ void ib_enum_roce_netdev(struct ib_device *ib_dev,
 			 roce_netdev_callback cb,
 			 void *cookie)
 {
-	unsigned int port;
+	u32 port;

 	rdma_for_each_port (ib_dev, port)
 		if (rdma_protocol_roce(ib_dev, port)) {
@@ -2369,7 +2373,7 @@ int ib_enum_all_devs(nldev_callback nldev_cb, struct sk_buff *skb,
  * ib_query_pkey() fetches the specified P_Key table entry.
  */
 int ib_query_pkey(struct ib_device *device,
-		  u8 port_num, u16 index, u16 *pkey)
+		  u32 port_num, u16 index, u16 *pkey)
 {
 	if (!rdma_is_port_valid(device, port_num))
 		return -EINVAL;
@@ -2414,7 +2418,7 @@ EXPORT_SYMBOL(ib_modify_device);
  * @port_modify_mask and @port_modify structure.
  */
 int ib_modify_port(struct ib_device *device,
-		   u8 port_num, int port_modify_mask,
+		   u32 port_num, int port_modify_mask,
 		   struct ib_port_modify *port_modify)
 {
 	int rc;
@@ -2446,10 +2450,10 @@ EXPORT_SYMBOL(ib_modify_port);
  *   parameter may be NULL.
  */
 int ib_find_gid(struct ib_device *device, union ib_gid *gid,
-		u8 *port_num, u16 *index)
+		u32 *port_num, u16 *index)
 {
 	union ib_gid tmp_gid;
-	unsigned int port;
+	u32 port;
 	int ret, i;

 	rdma_for_each_port (device, port) {
@@ -2483,7 +2487,7 @@ EXPORT_SYMBOL(ib_find_gid);
  * @index: The index into the PKey table where the PKey was found.
  */
 int ib_find_pkey(struct ib_device *device,
-		 u8 port_num, u16 pkey, u16 *index)
+		 u32 port_num, u16 pkey, u16 *index)
 {
 	int ret, i;
 	u16 tmp_pkey;
@@ -2526,7 +2530,7 @@ EXPORT_SYMBOL(ib_find_pkey);
  *
  */
 struct net_device *ib_get_net_dev_by_params(struct ib_device *dev,
-					    u8 port,
+					    u32 port,
 					    u16 pkey,
 					    const union ib_gid *gid,
 					    const struct sockaddr *addr)
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 9355e521d9f4..ce0397fd4b7d 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -61,7 +61,7 @@ static void create_mad_addr_info(struct ib_mad_send_wr_private *mad_send_wr,
 {
 	u16 pkey;
 	struct ib_device *dev = qp_info->port_priv->device;
-	u8 pnum = qp_info->port_priv->port_num;
+	u32 pnum = qp_info->port_priv->port_num;
 	struct ib_ud_wr *wr = &mad_send_wr->send_wr;
 	struct rdma_ah_attr attr = {};

@@ -118,7 +118,7 @@ static void ib_mad_send_done(struct ib_cq *cq, struct ib_wc *wc);
  * Assumes ib_mad_port_list_lock is being held
  */
 static inline struct ib_mad_port_private *
-__ib_get_mad_port(struct ib_device *device, int port_num)
+__ib_get_mad_port(struct ib_device *device, u32 port_num)
 {
 	struct ib_mad_port_private *entry;

@@ -134,7 +134,7 @@ __ib_get_mad_port(struct ib_device *device, int port_num)
  * for a device/port
  */
 static inline struct ib_mad_port_private *
-ib_get_mad_port(struct ib_device *device, int port_num)
+ib_get_mad_port(struct ib_device *device, u32 port_num)
 {
 	struct ib_mad_port_private *entry;
 	unsigned long flags;
@@ -222,7 +222,7 @@ EXPORT_SYMBOL(ib_response_mad);
  * Context: Process context.
  */
 struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
-					   u8 port_num,
+					   u32 port_num,
 					   enum ib_qp_type qp_type,
 					   struct ib_mad_reg_req *mad_reg_req,
 					   u8 rmpp_version,
@@ -549,7 +549,7 @@ static void dequeue_mad(struct ib_mad_list_head *mad_list)
 }

 static void build_smp_wc(struct ib_qp *qp, struct ib_cqe *cqe, u16 slid,
-		u16 pkey_index, u8 port_num, struct ib_wc *wc)
+		u16 pkey_index, u32 port_num, struct ib_wc *wc)
 {
 	memset(wc, 0, sizeof *wc);
 	wc->wr_cqe = cqe;
@@ -608,7 +608,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	struct ib_mad_port_private *port_priv;
 	struct ib_mad_agent_private *recv_mad_agent = NULL;
 	struct ib_device *device = mad_agent_priv->agent.device;
-	u8 port_num;
+	u32 port_num;
 	struct ib_wc mad_wc;
 	struct ib_ud_wr *send_wr = &mad_send_wr->send_wr;
 	size_t mad_size = port_mad_size(mad_agent_priv->qp_info->port_priv);
@@ -1613,7 +1613,7 @@ find_mad_agent(struct ib_mad_port_private *port_priv,

 	if (mad_agent && !mad_agent->agent.recv_handler) {
 		dev_notice(&port_priv->device->dev,
-			   "No receive handler for client %p on port %d\n",
+			   "No receive handler for client %p on port %u\n",
 			   &mad_agent->agent, port_priv->port_num);
 		deref_mad_agent(mad_agent);
 		mad_agent = NULL;
@@ -1685,7 +1685,7 @@ static inline int rcv_has_same_gid(const struct ib_mad_agent_private *mad_agent_
 	u8 send_resp, rcv_resp;
 	union ib_gid sgid;
 	struct ib_device *device = mad_agent_priv->agent.device;
-	u8 port_num = mad_agent_priv->agent.port_num;
+	u32 port_num = mad_agent_priv->agent.port_num;
 	u8 lmc;
 	bool has_grh;

@@ -1867,7 +1867,7 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 static enum smi_action handle_ib_smi(const struct ib_mad_port_private *port_priv,
 				     const struct ib_mad_qp_info *qp_info,
 				     const struct ib_wc *wc,
-				     int port_num,
+				     u32 port_num,
 				     struct ib_mad_private *recv,
 				     struct ib_mad_private *response)
 {
@@ -1954,7 +1954,7 @@ static enum smi_action
 handle_opa_smi(struct ib_mad_port_private *port_priv,
 	       struct ib_mad_qp_info *qp_info,
 	       struct ib_wc *wc,
-	       int port_num,
+	       u32 port_num,
 	       struct ib_mad_private *recv,
 	       struct ib_mad_private *response)
 {
@@ -2010,7 +2010,7 @@ static enum smi_action
 handle_smi(struct ib_mad_port_private *port_priv,
 	   struct ib_mad_qp_info *qp_info,
 	   struct ib_wc *wc,
-	   int port_num,
+	   u32 port_num,
 	   struct ib_mad_private *recv,
 	   struct ib_mad_private *response,
 	   bool opa)
@@ -2034,7 +2034,7 @@ static void ib_mad_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct ib_mad_private_header *mad_priv_hdr;
 	struct ib_mad_private *recv, *response = NULL;
 	struct ib_mad_agent_private *mad_agent;
-	int port_num;
+	u32 port_num;
 	int ret = IB_MAD_RESULT_SUCCESS;
 	size_t mad_size;
 	u16 resp_mad_pkey_index = 0;
@@ -2947,7 +2947,7 @@ static void destroy_mad_qp(struct ib_mad_qp_info *qp_info)
  * Create the QP, PD, MR, and CQ if needed
  */
 static int ib_mad_port_open(struct ib_device *device,
-			    int port_num)
+			    u32 port_num)
 {
 	int ret, cq_size;
 	struct ib_mad_port_private *port_priv;
@@ -3002,7 +3002,7 @@ static int ib_mad_port_open(struct ib_device *device,
 	if (ret)
 		goto error7;

-	snprintf(name, sizeof name, "ib_mad%d", port_num);
+	snprintf(name, sizeof(name), "ib_mad%u", port_num);
 	port_priv->wq = alloc_ordered_workqueue(name, WQ_MEM_RECLAIM);
 	if (!port_priv->wq) {
 		ret = -ENOMEM;
@@ -3048,7 +3048,7 @@ static int ib_mad_port_open(struct ib_device *device,
  * If there are no classes using the port, free the port
  * resources (CQ, MR, PD, QP) and remove the port's info structure
  */
-static int ib_mad_port_close(struct ib_device *device, int port_num)
+static int ib_mad_port_close(struct ib_device *device, u32 port_num)
 {
 	struct ib_mad_port_private *port_priv;
 	unsigned long flags;
@@ -3057,7 +3057,7 @@ static int ib_mad_port_close(struct ib_device *device, int port_num)
 	port_priv = __ib_get_mad_port(device, port_num);
 	if (port_priv == NULL) {
 		spin_unlock_irqrestore(&ib_mad_port_list_lock, flags);
-		dev_err(&device->dev, "Port %d not found\n", port_num);
+		dev_err(&device->dev, "Port %u not found\n", port_num);
 		return -ENODEV;
 	}
 	list_del_init(&port_priv->port_list);
diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index 57519ca6cd2c..a5dd4b7a74bc 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -63,7 +63,7 @@ struct mcast_port {
 	struct rb_root		table;
 	atomic_t		refcount;
 	struct completion	comp;
-	u8			port_num;
+	u32			port_num;
 };

 struct mcast_device {
@@ -605,7 +605,7 @@ static struct mcast_group *acquire_group(struct mcast_port *port,
  */
 struct ib_sa_multicast *
 ib_sa_join_multicast(struct ib_sa_client *client,
-		     struct ib_device *device, u8 port_num,
+		     struct ib_device *device, u32 port_num,
 		     struct ib_sa_mcmember_rec *rec,
 		     ib_sa_comp_mask comp_mask, gfp_t gfp_mask,
 		     int (*callback)(int status,
@@ -690,7 +690,7 @@ void ib_sa_free_multicast(struct ib_sa_multicast *multicast)
 }
 EXPORT_SYMBOL(ib_sa_free_multicast);

-int ib_sa_get_mcmember_rec(struct ib_device *device, u8 port_num,
+int ib_sa_get_mcmember_rec(struct ib_device *device, u32 port_num,
 			   union ib_gid *mgid, struct ib_sa_mcmember_rec *rec)
 {
 	struct mcast_device *dev;
@@ -732,7 +732,7 @@ EXPORT_SYMBOL(ib_sa_get_mcmember_rec);
  * success or appropriate error code.
  *
  */
-int ib_init_ah_from_mcmember(struct ib_device *device, u8 port_num,
+int ib_init_ah_from_mcmember(struct ib_device *device, u32 port_num,
 			     struct ib_sa_mcmember_rec *rec,
 			     struct net_device *ndev,
 			     enum ib_gid_type gid_type,
diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index d306049c22a2..b8dc002a2478 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -242,7 +242,7 @@ static int fill_dev_info(struct sk_buff *msg, struct ib_device *device)
 {
 	char fw[IB_FW_VERSION_NAME_MAX];
 	int ret = 0;
-	u8 port;
+	u32 port;

 	if (fill_nldev_handle(msg, device))
 		return -EMSGSIZE;
diff --git a/drivers/infiniband/core/opa_smi.h b/drivers/infiniband/core/opa_smi.h
index af4879bdf3d6..64e2822af70f 100644
--- a/drivers/infiniband/core/opa_smi.h
+++ b/drivers/infiniband/core/opa_smi.h
@@ -40,11 +40,11 @@
 #include "smi.h"

 enum smi_action opa_smi_handle_dr_smp_recv(struct opa_smp *smp, bool is_switch,
-				       int port_num, int phys_port_cnt);
+				       u32 port_num, int phys_port_cnt);
 int opa_smi_get_fwd_port(struct opa_smp *smp);
 extern enum smi_forward_action opa_smi_check_forward_dr_smp(struct opa_smp *smp);
 extern enum smi_action opa_smi_handle_dr_smp_send(struct opa_smp *smp,
-					      bool is_switch, int port_num);
+					      bool is_switch, u32 port_num);

 /*
  * Return IB_SMI_HANDLE if the SMP should be handled by the local SMA/SM
diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index 34fff94eaa38..7b638d91a4ec 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -70,7 +70,7 @@ struct netdev_event_work {
 };

 static const struct {
-	bool (*is_supported)(const struct ib_device *device, u8 port_num);
+	bool (*is_supported)(const struct ib_device *device, u32 port_num);
 	enum ib_gid_type gid_type;
 } PORT_CAP_TO_GID_TYPE[] = {
 	{rdma_protocol_roce_eth_encap, IB_GID_TYPE_ROCE},
@@ -79,7 +79,7 @@ static const struct {

 #define CAP_TO_GID_TABLE_SIZE	ARRAY_SIZE(PORT_CAP_TO_GID_TYPE)

-unsigned long roce_gid_type_mask_support(struct ib_device *ib_dev, u8 port)
+unsigned long roce_gid_type_mask_support(struct ib_device *ib_dev, u32 port)
 {
 	int i;
 	unsigned int ret_flags = 0;
@@ -96,7 +96,7 @@ unsigned long roce_gid_type_mask_support(struct ib_device *ib_dev, u8 port)
 EXPORT_SYMBOL(roce_gid_type_mask_support);

 static void update_gid(enum gid_op_type gid_op, struct ib_device *ib_dev,
-		       u8 port, union ib_gid *gid,
+		       u32 port, union ib_gid *gid,
 		       struct ib_gid_attr *gid_attr)
 {
 	int i;
@@ -144,7 +144,7 @@ static enum bonding_slave_state is_eth_active_slave_of_bonding_rcu(struct net_de
 #define REQUIRED_BOND_STATES		(BONDING_SLAVE_STATE_ACTIVE |	\
 					 BONDING_SLAVE_STATE_NA)
 static bool
-is_eth_port_of_netdev_filter(struct ib_device *ib_dev, u8 port,
+is_eth_port_of_netdev_filter(struct ib_device *ib_dev, u32 port,
 			     struct net_device *rdma_ndev, void *cookie)
 {
 	struct net_device *real_dev;
@@ -168,7 +168,7 @@ is_eth_port_of_netdev_filter(struct ib_device *ib_dev, u8 port,
 }

 static bool
-is_eth_port_inactive_slave_filter(struct ib_device *ib_dev, u8 port,
+is_eth_port_inactive_slave_filter(struct ib_device *ib_dev, u32 port,
 				  struct net_device *rdma_ndev, void *cookie)
 {
 	struct net_device *master_dev;
@@ -197,7 +197,7 @@ is_eth_port_inactive_slave_filter(struct ib_device *ib_dev, u8 port,
  * considered for deriving default RoCE GID, returns false otherwise.
  */
 static bool
-is_ndev_for_default_gid_filter(struct ib_device *ib_dev, u8 port,
+is_ndev_for_default_gid_filter(struct ib_device *ib_dev, u32 port,
 			       struct net_device *rdma_ndev, void *cookie)
 {
 	struct net_device *cookie_ndev = cookie;
@@ -223,13 +223,13 @@ is_ndev_for_default_gid_filter(struct ib_device *ib_dev, u8 port,
 	return res;
 }

-static bool pass_all_filter(struct ib_device *ib_dev, u8 port,
+static bool pass_all_filter(struct ib_device *ib_dev, u32 port,
 			    struct net_device *rdma_ndev, void *cookie)
 {
 	return true;
 }

-static bool upper_device_filter(struct ib_device *ib_dev, u8 port,
+static bool upper_device_filter(struct ib_device *ib_dev, u32 port,
 				struct net_device *rdma_ndev, void *cookie)
 {
 	bool res;
@@ -260,7 +260,7 @@ static bool upper_device_filter(struct ib_device *ib_dev, u8 port,
  * not have been established as slave device yet.
  */
 static bool
-is_upper_ndev_bond_master_filter(struct ib_device *ib_dev, u8 port,
+is_upper_ndev_bond_master_filter(struct ib_device *ib_dev, u32 port,
 				 struct net_device *rdma_ndev,
 				 void *cookie)
 {
@@ -280,7 +280,7 @@ is_upper_ndev_bond_master_filter(struct ib_device *ib_dev, u8 port,

 static void update_gid_ip(enum gid_op_type gid_op,
 			  struct ib_device *ib_dev,
-			  u8 port, struct net_device *ndev,
+			  u32 port, struct net_device *ndev,
 			  struct sockaddr *addr)
 {
 	union ib_gid gid;
@@ -294,7 +294,7 @@ static void update_gid_ip(enum gid_op_type gid_op,
 }

 static void bond_delete_netdev_default_gids(struct ib_device *ib_dev,
-					    u8 port,
+					    u32 port,
 					    struct net_device *rdma_ndev,
 					    struct net_device *event_ndev)
 {
@@ -328,7 +328,7 @@ static void bond_delete_netdev_default_gids(struct ib_device *ib_dev,
 }

 static void enum_netdev_ipv4_ips(struct ib_device *ib_dev,
-				 u8 port, struct net_device *ndev)
+				 u32 port, struct net_device *ndev)
 {
 	const struct in_ifaddr *ifa;
 	struct in_device *in_dev;
@@ -372,7 +372,7 @@ static void enum_netdev_ipv4_ips(struct ib_device *ib_dev,
 }

 static void enum_netdev_ipv6_ips(struct ib_device *ib_dev,
-				 u8 port, struct net_device *ndev)
+				 u32 port, struct net_device *ndev)
 {
 	struct inet6_ifaddr *ifp;
 	struct inet6_dev *in6_dev;
@@ -417,7 +417,7 @@ static void enum_netdev_ipv6_ips(struct ib_device *ib_dev,
 	}
 }

-static void _add_netdev_ips(struct ib_device *ib_dev, u8 port,
+static void _add_netdev_ips(struct ib_device *ib_dev, u32 port,
 			    struct net_device *ndev)
 {
 	enum_netdev_ipv4_ips(ib_dev, port, ndev);
@@ -425,13 +425,13 @@ static void _add_netdev_ips(struct ib_device *ib_dev, u8 port,
 		enum_netdev_ipv6_ips(ib_dev, port, ndev);
 }

-static void add_netdev_ips(struct ib_device *ib_dev, u8 port,
+static void add_netdev_ips(struct ib_device *ib_dev, u32 port,
 			   struct net_device *rdma_ndev, void *cookie)
 {
 	_add_netdev_ips(ib_dev, port, cookie);
 }

-static void del_netdev_ips(struct ib_device *ib_dev, u8 port,
+static void del_netdev_ips(struct ib_device *ib_dev, u32 port,
 			   struct net_device *rdma_ndev, void *cookie)
 {
 	ib_cache_gid_del_all_netdev_gids(ib_dev, port, cookie);
@@ -446,7 +446,7 @@ static void del_netdev_ips(struct ib_device *ib_dev, u8 port,
  *
  * del_default_gids() deletes the default GIDs of the event/cookie netdevice.
  */
-static void del_default_gids(struct ib_device *ib_dev, u8 port,
+static void del_default_gids(struct ib_device *ib_dev, u32 port,
 			     struct net_device *rdma_ndev, void *cookie)
 {
 	struct net_device *cookie_ndev = cookie;
@@ -458,7 +458,7 @@ static void del_default_gids(struct ib_device *ib_dev, u8 port,
 				     IB_CACHE_GID_DEFAULT_MODE_DELETE);
 }

-static void add_default_gids(struct ib_device *ib_dev, u8 port,
+static void add_default_gids(struct ib_device *ib_dev, u32 port,
 			     struct net_device *rdma_ndev, void *cookie)
 {
 	struct net_device *event_ndev = cookie;
@@ -470,7 +470,7 @@ static void add_default_gids(struct ib_device *ib_dev, u8 port,
 }

 static void enum_all_gids_of_dev_cb(struct ib_device *ib_dev,
-				    u8 port,
+				    u32 port,
 				    struct net_device *rdma_ndev,
 				    void *cookie)
 {
@@ -515,7 +515,7 @@ void rdma_roce_rescan_device(struct ib_device *ib_dev)
 EXPORT_SYMBOL(rdma_roce_rescan_device);

 static void callback_for_addr_gid_device_scan(struct ib_device *device,
-					      u8 port,
+					      u32 port,
 					      struct net_device *rdma_ndev,
 					      void *cookie)
 {
@@ -547,10 +547,10 @@ static int netdev_upper_walk(struct net_device *upper,
 	return 0;
 }

-static void handle_netdev_upper(struct ib_device *ib_dev, u8 port,
+static void handle_netdev_upper(struct ib_device *ib_dev, u32 port,
 				void *cookie,
 				void (*handle_netdev)(struct ib_device *ib_dev,
-						      u8 port,
+						      u32 port,
 						      struct net_device *ndev))
 {
 	struct net_device *ndev = cookie;
@@ -574,25 +574,25 @@ static void handle_netdev_upper(struct ib_device *ib_dev, u8 port,
 	}
 }

-static void _roce_del_all_netdev_gids(struct ib_device *ib_dev, u8 port,
+static void _roce_del_all_netdev_gids(struct ib_device *ib_dev, u32 port,
 				      struct net_device *event_ndev)
 {
 	ib_cache_gid_del_all_netdev_gids(ib_dev, port, event_ndev);
 }

-static void del_netdev_upper_ips(struct ib_device *ib_dev, u8 port,
+static void del_netdev_upper_ips(struct ib_device *ib_dev, u32 port,
 				 struct net_device *rdma_ndev, void *cookie)
 {
 	handle_netdev_upper(ib_dev, port, cookie, _roce_del_all_netdev_gids);
 }

-static void add_netdev_upper_ips(struct ib_device *ib_dev, u8 port,
+static void add_netdev_upper_ips(struct ib_device *ib_dev, u32 port,
 				 struct net_device *rdma_ndev, void *cookie)
 {
 	handle_netdev_upper(ib_dev, port, cookie, _add_netdev_ips);
 }

-static void del_netdev_default_ips_join(struct ib_device *ib_dev, u8 port,
+static void del_netdev_default_ips_join(struct ib_device *ib_dev, u32 port,
 					struct net_device *rdma_ndev,
 					void *cookie)
 {
diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index 31156e22d3e7..a588c2038479 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -25,7 +25,7 @@ MODULE_PARM_DESC(force_mr, "Force usage of MRs for RDMA READ/WRITE operations");
  * registration is also enabled if registering memory might yield better
  * performance than using multiple SGE entries, see rdma_rw_io_needs_mr()
  */
-static inline bool rdma_rw_can_use_mr(struct ib_device *dev, u8 port_num)
+static inline bool rdma_rw_can_use_mr(struct ib_device *dev, u32 port_num)
 {
 	if (rdma_protocol_iwarp(dev, port_num))
 		return true;
@@ -42,7 +42,7 @@ static inline bool rdma_rw_can_use_mr(struct ib_device *dev, u8 port_num)
  * optimization otherwise.  Additionally we have a debug option to force usage
  * of MRs to help testing this code path.
  */
-static inline bool rdma_rw_io_needs_mr(struct ib_device *dev, u8 port_num,
+static inline bool rdma_rw_io_needs_mr(struct ib_device *dev, u32 port_num,
 		enum dma_data_direction dir, int dma_nents)
 {
 	if (dir == DMA_FROM_DEVICE) {
@@ -87,7 +87,7 @@ static inline int rdma_rw_inv_key(struct rdma_rw_reg_ctx *reg)
 }

 /* Caller must have zero-initialized *reg. */
-static int rdma_rw_init_one_mr(struct ib_qp *qp, u8 port_num,
+static int rdma_rw_init_one_mr(struct ib_qp *qp, u32 port_num,
 		struct rdma_rw_reg_ctx *reg, struct scatterlist *sg,
 		u32 sg_cnt, u32 offset)
 {
@@ -121,7 +121,7 @@ static int rdma_rw_init_one_mr(struct ib_qp *qp, u8 port_num,
 }

 static int rdma_rw_init_mr_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
-		u8 port_num, struct scatterlist *sg, u32 sg_cnt, u32 offset,
+		u32 port_num, struct scatterlist *sg, u32 sg_cnt, u32 offset,
 		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
 {
 	struct rdma_rw_reg_ctx *prev = NULL;
@@ -308,7 +308,7 @@ static int rdma_rw_map_sg(struct ib_device *dev, struct scatterlist *sg,
  * Returns the number of WQEs that will be needed on the workqueue if
  * successful, or a negative error code.
  */
-int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
+int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u32 port_num,
 		struct scatterlist *sg, u32 sg_cnt, u32 sg_offset,
 		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
 {
@@ -377,7 +377,7 @@ EXPORT_SYMBOL(rdma_rw_ctx_init);
  * successful, or a negative error code.
  */
 int rdma_rw_ctx_signature_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
-		u8 port_num, struct scatterlist *sg, u32 sg_cnt,
+		u32 port_num, struct scatterlist *sg, u32 sg_cnt,
 		struct scatterlist *prot_sg, u32 prot_sg_cnt,
 		struct ib_sig_attrs *sig_attrs,
 		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
@@ -505,7 +505,7 @@ static void rdma_rw_update_lkey(struct rdma_rw_reg_ctx *reg, bool need_inval)
  * completion notification.
  */
 struct ib_send_wr *rdma_rw_ctx_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
-		u8 port_num, struct ib_cqe *cqe, struct ib_send_wr *chain_wr)
+		u32 port_num, struct ib_cqe *cqe, struct ib_send_wr *chain_wr)
 {
 	struct ib_send_wr *first_wr, *last_wr;
 	int i;
@@ -562,7 +562,7 @@ EXPORT_SYMBOL(rdma_rw_ctx_wrs);
  * is not set @cqe must be set so that the caller gets a completion
  * notification.
  */
-int rdma_rw_ctx_post(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
+int rdma_rw_ctx_post(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u32 port_num,
 		struct ib_cqe *cqe, struct ib_send_wr *chain_wr)
 {
 	struct ib_send_wr *first_wr;
@@ -581,8 +581,9 @@ EXPORT_SYMBOL(rdma_rw_ctx_post);
  * @sg_cnt:	number of entries in @sg
  * @dir:	%DMA_TO_DEVICE for RDMA WRITE, %DMA_FROM_DEVICE for RDMA READ
  */
-void rdma_rw_ctx_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
-		struct scatterlist *sg, u32 sg_cnt, enum dma_data_direction dir)
+void rdma_rw_ctx_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
+			 u32 port_num, struct scatterlist *sg, u32 sg_cnt,
+			 enum dma_data_direction dir)
 {
 	int i;

@@ -620,7 +621,7 @@ EXPORT_SYMBOL(rdma_rw_ctx_destroy);
  * @dir:	%DMA_TO_DEVICE for RDMA WRITE, %DMA_FROM_DEVICE for RDMA READ
  */
 void rdma_rw_ctx_destroy_signature(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
-		u8 port_num, struct scatterlist *sg, u32 sg_cnt,
+		u32 port_num, struct scatterlist *sg, u32 sg_cnt,
 		struct scatterlist *prot_sg, u32 prot_sg_cnt,
 		enum dma_data_direction dir)
 {
@@ -647,7 +648,7 @@ EXPORT_SYMBOL(rdma_rw_ctx_destroy_signature);
  * compute max_rdma_ctxts and the size of the transport's Send and
  * Send Completion Queues.
  */
-unsigned int rdma_rw_mr_factor(struct ib_device *device, u8 port_num,
+unsigned int rdma_rw_mr_factor(struct ib_device *device, u32 port_num,
 			       unsigned int maxpages)
 {
 	unsigned int mr_pages;
diff --git a/drivers/infiniband/core/sa.h b/drivers/infiniband/core/sa.h
index cbaaaa92fff3..143de37ae598 100644
--- a/drivers/infiniband/core/sa.h
+++ b/drivers/infiniband/core/sa.h
@@ -49,7 +49,7 @@ static inline void ib_sa_client_put(struct ib_sa_client *client)
 }

 int ib_sa_mcmember_rec_query(struct ib_sa_client *client,
-			     struct ib_device *device, u8 port_num, u8 method,
+			     struct ib_device *device, u32 port_num, u8 method,
 			     struct ib_sa_mcmember_rec *rec,
 			     ib_sa_comp_mask comp_mask,
 			     unsigned long timeout_ms, gfp_t gfp_mask,
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 9ef1a355131b..8f1705c403b4 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -95,7 +95,7 @@ struct ib_sa_port {
 	struct delayed_work ib_cpi_work;
 	spinlock_t                   classport_lock; /* protects class port info set */
 	spinlock_t           ah_lock;
-	u8                   port_num;
+	u32		     port_num;
 };

 struct ib_sa_device {
@@ -1194,7 +1194,7 @@ void ib_sa_cancel_query(int id, struct ib_sa_query *query)
 }
 EXPORT_SYMBOL(ib_sa_cancel_query);

-static u8 get_src_path_mask(struct ib_device *device, u8 port_num)
+static u8 get_src_path_mask(struct ib_device *device, u32 port_num)
 {
 	struct ib_sa_device *sa_dev;
 	struct ib_sa_port   *port;
@@ -1213,7 +1213,7 @@ static u8 get_src_path_mask(struct ib_device *device, u8 port_num)
 	return src_path_mask;
 }

-static int init_ah_attr_grh_fields(struct ib_device *device, u8 port_num,
+static int init_ah_attr_grh_fields(struct ib_device *device, u32 port_num,
 				   struct sa_path_rec *rec,
 				   struct rdma_ah_attr *ah_attr,
 				   const struct ib_gid_attr *gid_attr)
@@ -1251,7 +1251,7 @@ static int init_ah_attr_grh_fields(struct ib_device *device, u8 port_num,
  * User must invoke rdma_destroy_ah_attr() to release reference to SGID
  * attributes which are initialized using ib_init_ah_attr_from_path().
  */
-int ib_init_ah_attr_from_path(struct ib_device *device, u8 port_num,
+int ib_init_ah_attr_from_path(struct ib_device *device, u32 port_num,
 			      struct sa_path_rec *rec,
 			      struct rdma_ah_attr *ah_attr,
 			      const struct ib_gid_attr *gid_attr)
@@ -1409,7 +1409,7 @@ EXPORT_SYMBOL(ib_sa_pack_path);

 static bool ib_sa_opa_pathrecord_support(struct ib_sa_client *client,
 					 struct ib_sa_device *sa_dev,
-					 u8 port_num)
+					 u32 port_num)
 {
 	struct ib_sa_port *port;
 	unsigned long flags;
@@ -1444,7 +1444,7 @@ enum opa_pr_supported {
  */
 static int opa_pr_query_possible(struct ib_sa_client *client,
 				 struct ib_sa_device *sa_dev,
-				 struct ib_device *device, u8 port_num,
+				 struct ib_device *device, u32 port_num,
 				 struct sa_path_rec *rec)
 {
 	struct ib_port_attr port_attr;
@@ -1533,7 +1533,7 @@ static void ib_sa_path_rec_release(struct ib_sa_query *sa_query)
  * the query.
  */
 int ib_sa_path_rec_get(struct ib_sa_client *client,
-		       struct ib_device *device, u8 port_num,
+		       struct ib_device *device, u32 port_num,
 		       struct sa_path_rec *rec,
 		       ib_sa_comp_mask comp_mask,
 		       unsigned long timeout_ms, gfp_t gfp_mask,
@@ -1688,7 +1688,7 @@ static void ib_sa_service_rec_release(struct ib_sa_query *sa_query)
  * the query.
  */
 int ib_sa_service_rec_query(struct ib_sa_client *client,
-			    struct ib_device *device, u8 port_num, u8 method,
+			    struct ib_device *device, u32 port_num, u8 method,
 			    struct ib_sa_service_rec *rec,
 			    ib_sa_comp_mask comp_mask,
 			    unsigned long timeout_ms, gfp_t gfp_mask,
@@ -1784,7 +1784,7 @@ static void ib_sa_mcmember_rec_release(struct ib_sa_query *sa_query)
 }

 int ib_sa_mcmember_rec_query(struct ib_sa_client *client,
-			     struct ib_device *device, u8 port_num,
+			     struct ib_device *device, u32 port_num,
 			     u8 method,
 			     struct ib_sa_mcmember_rec *rec,
 			     ib_sa_comp_mask comp_mask,
@@ -1876,7 +1876,7 @@ static void ib_sa_guidinfo_rec_release(struct ib_sa_query *sa_query)
 }

 int ib_sa_guid_info_rec_query(struct ib_sa_client *client,
-			      struct ib_device *device, u8 port_num,
+			      struct ib_device *device, u32 port_num,
 			      struct ib_sa_guidinfo_rec *rec,
 			      ib_sa_comp_mask comp_mask, u8 method,
 			      unsigned long timeout_ms, gfp_t gfp_mask,
@@ -2265,7 +2265,7 @@ static void ib_sa_event(struct ib_event_handler *handler,
 		unsigned long flags;
 		struct ib_sa_device *sa_dev =
 			container_of(handler, typeof(*sa_dev), event_handler);
-		u8 port_num = event->element.port_num - sa_dev->start_port;
+		u32 port_num = event->element.port_num - sa_dev->start_port;
 		struct ib_sa_port *port = &sa_dev->port[port_num];

 		if (!rdma_cap_ib_sa(handler->device, port->port_num))
diff --git a/drivers/infiniband/core/security.c b/drivers/infiniband/core/security.c
index 75e7ec017836..e5a78d1a63c9 100644
--- a/drivers/infiniband/core/security.c
+++ b/drivers/infiniband/core/security.c
@@ -193,7 +193,7 @@ static void qp_to_error(struct ib_qp_security *sec)

 static inline void check_pkey_qps(struct pkey_index_qp_list *pkey,
 				  struct ib_device *device,
-				  u8 port_num,
+				  u32 port_num,
 				  u64 subnet_prefix)
 {
 	struct ib_port_pkey *pp, *tmp_pp;
@@ -245,7 +245,7 @@ static int port_pkey_list_insert(struct ib_port_pkey *pp)
 	struct pkey_index_qp_list *tmp_pkey;
 	struct pkey_index_qp_list *pkey;
 	struct ib_device *dev;
-	u8 port_num = pp->port_num;
+	u32 port_num = pp->port_num;
 	int ret = 0;

 	if (pp->state != IB_PORT_PKEY_VALID)
@@ -538,7 +538,7 @@ void ib_destroy_qp_security_end(struct ib_qp_security *sec)
 }

 void ib_security_cache_change(struct ib_device *device,
-			      u8 port_num,
+			      u32 port_num,
 			      u64 subnet_prefix)
 {
 	struct pkey_index_qp_list *pkey;
@@ -649,7 +649,7 @@ int ib_security_modify_qp(struct ib_qp *qp,
 }

 static int ib_security_pkey_access(struct ib_device *dev,
-				   u8 port_num,
+				   u32 port_num,
 				   u16 pkey_index,
 				   void *sec)
 {
diff --git a/drivers/infiniband/core/smi.c b/drivers/infiniband/core/smi.c
index f19b23817c2b..45f09b75c893 100644
--- a/drivers/infiniband/core/smi.c
+++ b/drivers/infiniband/core/smi.c
@@ -41,7 +41,7 @@
 #include "smi.h"
 #include "opa_smi.h"

-static enum smi_action __smi_handle_dr_smp_send(bool is_switch, int port_num,
+static enum smi_action __smi_handle_dr_smp_send(bool is_switch, u32 port_num,
 						u8 *hop_ptr, u8 hop_cnt,
 						const u8 *initial_path,
 						const u8 *return_path,
@@ -127,7 +127,7 @@ static enum smi_action __smi_handle_dr_smp_send(bool is_switch, int port_num,
  * Return IB_SMI_DISCARD if the SMP should be discarded
  */
 enum smi_action smi_handle_dr_smp_send(struct ib_smp *smp,
-				       bool is_switch, int port_num)
+				       bool is_switch, u32 port_num)
 {
 	return __smi_handle_dr_smp_send(is_switch, port_num,
 					&smp->hop_ptr, smp->hop_cnt,
@@ -139,7 +139,7 @@ enum smi_action smi_handle_dr_smp_send(struct ib_smp *smp,
 }

 enum smi_action opa_smi_handle_dr_smp_send(struct opa_smp *smp,
-				       bool is_switch, int port_num)
+				       bool is_switch, u32 port_num)
 {
 	return __smi_handle_dr_smp_send(is_switch, port_num,
 					&smp->hop_ptr, smp->hop_cnt,
@@ -152,7 +152,7 @@ enum smi_action opa_smi_handle_dr_smp_send(struct opa_smp *smp,
 					OPA_LID_PERMISSIVE);
 }

-static enum smi_action __smi_handle_dr_smp_recv(bool is_switch, int port_num,
+static enum smi_action __smi_handle_dr_smp_recv(bool is_switch, u32 port_num,
 						int phys_port_cnt,
 						u8 *hop_ptr, u8 hop_cnt,
 						const u8 *initial_path,
@@ -238,7 +238,7 @@ static enum smi_action __smi_handle_dr_smp_recv(bool is_switch, int port_num,
  * Return IB_SMI_DISCARD if the SMP should be dropped
  */
 enum smi_action smi_handle_dr_smp_recv(struct ib_smp *smp, bool is_switch,
-				       int port_num, int phys_port_cnt)
+				       u32 port_num, int phys_port_cnt)
 {
 	return __smi_handle_dr_smp_recv(is_switch, port_num, phys_port_cnt,
 					&smp->hop_ptr, smp->hop_cnt,
@@ -254,7 +254,7 @@ enum smi_action smi_handle_dr_smp_recv(struct ib_smp *smp, bool is_switch,
  * Return IB_SMI_DISCARD if the SMP should be dropped
  */
 enum smi_action opa_smi_handle_dr_smp_recv(struct opa_smp *smp, bool is_switch,
-					   int port_num, int phys_port_cnt)
+					   u32 port_num, int phys_port_cnt)
 {
 	return __smi_handle_dr_smp_recv(is_switch, port_num, phys_port_cnt,
 					&smp->hop_ptr, smp->hop_cnt,
diff --git a/drivers/infiniband/core/smi.h b/drivers/infiniband/core/smi.h
index 91d9b353ab85..e350ed623c45 100644
--- a/drivers/infiniband/core/smi.h
+++ b/drivers/infiniband/core/smi.h
@@ -52,11 +52,11 @@ enum smi_forward_action {
 };

 enum smi_action smi_handle_dr_smp_recv(struct ib_smp *smp, bool is_switch,
-				       int port_num, int phys_port_cnt);
+				       u32 port_num, int phys_port_cnt);
 int smi_get_fwd_port(struct ib_smp *smp);
 extern enum smi_forward_action smi_check_forward_dr_smp(struct ib_smp *smp);
 extern enum smi_action smi_handle_dr_smp_send(struct ib_smp *smp,
-					      bool is_switch, int port_num);
+					      bool is_switch, u32 port_num);

 /*
  * Return IB_SMI_HANDLE if the SMP should be handled by the local SMA/SM
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index b8abb30f80df..91a53b2b4718 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -62,7 +62,7 @@ struct ib_port {
 	const struct attribute_group *pma_table;
 	struct attribute_group *hw_stats_ag;
 	struct rdma_hw_stats   *hw_stats;
-	u8                     port_num;
+	u32                     port_num;
 };

 struct port_attribute {
@@ -94,7 +94,7 @@ struct hw_stats_attribute {
 					 const char *buf,
 					 size_t count);
 	int			index;
-	u8			port_num;
+	u32			port_num;
 };

 static ssize_t port_attr_show(struct kobject *kobj,
@@ -812,7 +812,7 @@ static const struct attribute_group *get_counter_table(struct ib_device *dev,
 }

 static int update_hw_stats(struct ib_device *dev, struct rdma_hw_stats *stats,
-			   u8 port_num, int index)
+			   u32 port_num, int index)
 {
 	int ret;

@@ -938,7 +938,7 @@ static void free_hsag(struct kobject *kobj, struct attribute_group *attr_group)
 	kfree(attr_group);
 }

-static struct attribute *alloc_hsa(int index, u8 port_num, const char *name)
+static struct attribute *alloc_hsa(int index, u32 port_num, const char *name)
 {
 	struct hw_stats_attribute *hsa;

@@ -956,7 +956,7 @@ static struct attribute *alloc_hsa(int index, u8 port_num, const char *name)
 	return &hsa->attr;
 }

-static struct attribute *alloc_hsa_lifespan(char *name, u8 port_num)
+static struct attribute *alloc_hsa_lifespan(char *name, u32 port_num)
 {
 	struct hw_stats_attribute *hsa;

@@ -975,7 +975,7 @@ static struct attribute *alloc_hsa_lifespan(char *name, u8 port_num)
 }

 static void setup_hw_stats(struct ib_device *device, struct ib_port *port,
-			   u8 port_num)
+			   u32 port_num)
 {
 	struct attribute_group *hsag;
 	struct rdma_hw_stats *stats;
@@ -1383,7 +1383,7 @@ void ib_free_port_attrs(struct ib_core_device *coredev)
 int ib_setup_port_attrs(struct ib_core_device *coredev)
 {
 	struct ib_device *device = rdma_device_to_ibdev(&coredev->dev);
-	unsigned int port;
+	u32 port;
 	int ret;

 	coredev->ports_kobj = kobject_create_and_add("ports",
@@ -1437,7 +1437,7 @@ void ib_device_unregister_sysfs(struct ib_device *device)
  * @ktype: pointer to the ktype for this kobject.
  * @name: the name of the kobject
  */
-int ib_port_register_module_stat(struct ib_device *device, u8 port_num,
+int ib_port_register_module_stat(struct ib_device *device, u32 port_num,
 				 struct kobject *kobj, struct kobj_type *ktype,
 				 const char *name)
 {
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index dd7f3b437c6b..a183b2747c3e 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -101,7 +101,7 @@ struct ib_umad_port {
 	struct ib_device      *ib_dev;
 	struct ib_umad_device *umad_dev;
 	int                    dev_num;
-	u8                     port_num;
+	u32                     port_num;
 };

 struct ib_umad_device {
@@ -1145,7 +1145,7 @@ static const struct file_operations umad_sm_fops = {

 static struct ib_umad_port *get_port(struct ib_device *ibdev,
 				     struct ib_umad_device *umad_dev,
-				     unsigned int port)
+				     u32 port)
 {
 	if (!umad_dev)
 		return ERR_PTR(-EOPNOTSUPP);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index f5b8be3bedde..9e070ffa3520 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -364,7 +364,7 @@ static void copy_query_dev_fields(struct ib_ucontext *ucontext,
 	resp->max_srq_sge		= attr->max_srq_sge;
 	resp->max_pkeys			= attr->max_pkeys;
 	resp->local_ca_ack_delay	= attr->local_ca_ack_delay;
-	resp->phys_port_cnt		= ib_dev->phys_port_cnt;
+	resp->phys_port_cnt = min_t(u32, ib_dev->phys_port_cnt, U8_MAX);
 }

 static int ib_uverbs_query_device(struct uverbs_attr_bundle *attrs)
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 28464c58738c..c576e2bc39c6 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -227,7 +227,8 @@ rdma_node_get_transport(unsigned int node_type)
 }
 EXPORT_SYMBOL(rdma_node_get_transport);

-enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *device, u8 port_num)
+enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *device,
+					      u32 port_num)
 {
 	enum rdma_transport_type lt;
 	if (device->ops.get_link_layer)
@@ -658,7 +659,7 @@ int ib_get_rdma_header_version(const union rdma_network_hdr *hdr)
 EXPORT_SYMBOL(ib_get_rdma_header_version);

 static enum rdma_network_type ib_get_net_type_by_grh(struct ib_device *device,
-						     u8 port_num,
+						     u32 port_num,
 						     const struct ib_grh *grh)
 {
 	int grh_version;
@@ -701,7 +702,7 @@ static bool find_gid_index(const union ib_gid *gid,
 }

 static const struct ib_gid_attr *
-get_sgid_attr_from_eth(struct ib_device *device, u8 port_num,
+get_sgid_attr_from_eth(struct ib_device *device, u32 port_num,
 		       u16 vlan_id, const union ib_gid *sgid,
 		       enum ib_gid_type gid_type)
 {
@@ -788,7 +789,7 @@ static int ib_resolve_unicast_gid_dmac(struct ib_device *device,
  * On success the caller is responsible to call rdma_destroy_ah_attr on the
  * attr.
  */
-int ib_init_ah_attr_from_wc(struct ib_device *device, u8 port_num,
+int ib_init_ah_attr_from_wc(struct ib_device *device, u32 port_num,
 			    const struct ib_wc *wc, const struct ib_grh *grh,
 			    struct rdma_ah_attr *ah_attr)
 {
@@ -919,7 +920,7 @@ void rdma_destroy_ah_attr(struct rdma_ah_attr *ah_attr)
 EXPORT_SYMBOL(rdma_destroy_ah_attr);

 struct ib_ah *ib_create_ah_from_wc(struct ib_pd *pd, const struct ib_wc *wc,
-				   const struct ib_grh *grh, u8 port_num)
+				   const struct ib_grh *grh, u32 port_num)
 {
 	struct rdma_ah_attr ah_attr;
 	struct ib_ah *ah;
@@ -1673,7 +1674,7 @@ static bool is_qp_type_connected(const struct ib_qp *qp)
 static int _ib_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
 			 int attr_mask, struct ib_udata *udata)
 {
-	u8 port = attr_mask & IB_QP_PORT ? attr->port_num : qp->port;
+	u32 port = attr_mask & IB_QP_PORT ? attr->port_num : qp->port;
 	const struct ib_gid_attr *old_sgid_attr_av;
 	const struct ib_gid_attr *old_sgid_attr_alt_av;
 	int ret;
@@ -1801,7 +1802,7 @@ int ib_modify_qp_with_udata(struct ib_qp *ib_qp, struct ib_qp_attr *attr,
 }
 EXPORT_SYMBOL(ib_modify_qp_with_udata);

-int ib_get_eth_speed(struct ib_device *dev, u8 port_num, u16 *speed, u8 *width)
+int ib_get_eth_speed(struct ib_device *dev, u32 port_num, u16 *speed, u8 *width)
 {
 	int rc;
 	u32 netdev_speed;
@@ -2467,7 +2468,7 @@ int ib_check_mr_status(struct ib_mr *mr, u32 check_mask,
 }
 EXPORT_SYMBOL(ib_check_mr_status);

-int ib_set_vf_link_state(struct ib_device *device, int vf, u8 port,
+int ib_set_vf_link_state(struct ib_device *device, int vf, u32 port,
 			 int state)
 {
 	if (!device->ops.set_vf_link_state)
@@ -2477,7 +2478,7 @@ int ib_set_vf_link_state(struct ib_device *device, int vf, u8 port,
 }
 EXPORT_SYMBOL(ib_set_vf_link_state);

-int ib_get_vf_config(struct ib_device *device, int vf, u8 port,
+int ib_get_vf_config(struct ib_device *device, int vf, u32 port,
 		     struct ifla_vf_info *info)
 {
 	if (!device->ops.get_vf_config)
@@ -2487,7 +2488,7 @@ int ib_get_vf_config(struct ib_device *device, int vf, u8 port,
 }
 EXPORT_SYMBOL(ib_get_vf_config);

-int ib_get_vf_stats(struct ib_device *device, int vf, u8 port,
+int ib_get_vf_stats(struct ib_device *device, int vf, u32 port,
 		    struct ifla_vf_stats *stats)
 {
 	if (!device->ops.get_vf_stats)
@@ -2497,7 +2498,7 @@ int ib_get_vf_stats(struct ib_device *device, int vf, u8 port,
 }
 EXPORT_SYMBOL(ib_get_vf_stats);

-int ib_set_vf_guid(struct ib_device *device, int vf, u8 port, u64 guid,
+int ib_set_vf_guid(struct ib_device *device, int vf, u32 port, u64 guid,
 		   int type)
 {
 	if (!device->ops.set_vf_guid)
@@ -2507,7 +2508,7 @@ int ib_set_vf_guid(struct ib_device *device, int vf, u8 port, u64 guid,
 }
 EXPORT_SYMBOL(ib_set_vf_guid);

-int ib_get_vf_guid(struct ib_device *device, int vf, u8 port,
+int ib_get_vf_guid(struct ib_device *device, int vf, u32 port,
 		   struct ifla_vf_guid *node_guid,
 		   struct ifla_vf_guid *port_guid)
 {
@@ -2849,7 +2850,7 @@ void ib_drain_qp(struct ib_qp *qp)
 }
 EXPORT_SYMBOL(ib_drain_qp);

-struct net_device *rdma_alloc_netdev(struct ib_device *device, u8 port_num,
+struct net_device *rdma_alloc_netdev(struct ib_device *device, u32 port_num,
 				     enum rdma_netdev_t type, const char *name,
 				     unsigned char name_assign_type,
 				     void (*setup)(struct net_device *))
@@ -2875,7 +2876,7 @@ struct net_device *rdma_alloc_netdev(struct ib_device *device, u8 port_num,
 }
 EXPORT_SYMBOL(rdma_alloc_netdev);

-int rdma_init_netdev(struct ib_device *device, u8 port_num,
+int rdma_init_netdev(struct ib_device *device, u32 port_num,
 		     enum rdma_netdev_t type, const char *name,
 		     unsigned char name_assign_type,
 		     void (*setup)(struct net_device *),
diff --git a/drivers/infiniband/hw/bnxt_re/hw_counters.c b/drivers/infiniband/hw/bnxt_re/hw_counters.c
index 5f5408cdf008..3e54e1ae75b4 100644
--- a/drivers/infiniband/hw/bnxt_re/hw_counters.c
+++ b/drivers/infiniband/hw/bnxt_re/hw_counters.c
@@ -114,7 +114,7 @@ static const char * const bnxt_re_stat_name[] = {

 int bnxt_re_ib_get_hw_stats(struct ib_device *ibdev,
 			    struct rdma_hw_stats *stats,
-			    u8 port, int index)
+			    u32 port, int index)
 {
 	struct bnxt_re_dev *rdev = to_bnxt_re_dev(ibdev, ibdev);
 	struct ctx_hw_stats *bnxt_re_stats = rdev->qplib_ctx.stats.dma;
@@ -235,7 +235,7 @@ int bnxt_re_ib_get_hw_stats(struct ib_device *ibdev,
 }

 struct rdma_hw_stats *bnxt_re_ib_alloc_hw_stats(struct ib_device *ibdev,
-						u8 port_num)
+						u32 port_num)
 {
 	BUILD_BUG_ON(ARRAY_SIZE(bnxt_re_stat_name) != BNXT_RE_NUM_COUNTERS);
 	/* We support only per port stats */
diff --git a/drivers/infiniband/hw/bnxt_re/hw_counters.h b/drivers/infiniband/hw/bnxt_re/hw_counters.h
index 76399f477e5c..ede048607d6c 100644
--- a/drivers/infiniband/hw/bnxt_re/hw_counters.h
+++ b/drivers/infiniband/hw/bnxt_re/hw_counters.h
@@ -97,8 +97,8 @@ enum bnxt_re_hw_stats {
 };

 struct rdma_hw_stats *bnxt_re_ib_alloc_hw_stats(struct ib_device *ibdev,
-						u8 port_num);
+						u32 port_num);
 int bnxt_re_ib_get_hw_stats(struct ib_device *ibdev,
 			    struct rdma_hw_stats *stats,
-			    u8 port, int index);
+			    u32 port, int index);
 #endif /* __BNXT_RE_HW_STATS_H__ */
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index ba515efd4fdc..2efaa80bfbd2 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -189,7 +189,7 @@ int bnxt_re_query_device(struct ib_device *ibdev,
 }

 /* Port */
-int bnxt_re_query_port(struct ib_device *ibdev, u8 port_num,
+int bnxt_re_query_port(struct ib_device *ibdev, u32 port_num,
 		       struct ib_port_attr *port_attr)
 {
 	struct bnxt_re_dev *rdev = to_bnxt_re_dev(ibdev, ibdev);
@@ -229,7 +229,7 @@ int bnxt_re_query_port(struct ib_device *ibdev, u8 port_num,
 	return 0;
 }

-int bnxt_re_get_port_immutable(struct ib_device *ibdev, u8 port_num,
+int bnxt_re_get_port_immutable(struct ib_device *ibdev, u32 port_num,
 			       struct ib_port_immutable *immutable)
 {
 	struct ib_port_attr port_attr;
@@ -254,7 +254,7 @@ void bnxt_re_query_fw_str(struct ib_device *ibdev, char *str)
 		 rdev->dev_attr.fw_ver[2], rdev->dev_attr.fw_ver[3]);
 }

-int bnxt_re_query_pkey(struct ib_device *ibdev, u8 port_num,
+int bnxt_re_query_pkey(struct ib_device *ibdev, u32 port_num,
 		       u16 index, u16 *pkey)
 {
 	struct bnxt_re_dev *rdev = to_bnxt_re_dev(ibdev, ibdev);
@@ -266,7 +266,7 @@ int bnxt_re_query_pkey(struct ib_device *ibdev, u8 port_num,
 				   &rdev->qplib_res.pkey_tbl, index, pkey);
 }

-int bnxt_re_query_gid(struct ib_device *ibdev, u8 port_num,
+int bnxt_re_query_gid(struct ib_device *ibdev, u32 port_num,
 		      int index, union ib_gid *gid)
 {
 	struct bnxt_re_dev *rdev = to_bnxt_re_dev(ibdev, ibdev);
@@ -374,7 +374,7 @@ int bnxt_re_add_gid(const struct ib_gid_attr *attr, void **context)
 }

 enum rdma_link_layer bnxt_re_get_link_layer(struct ib_device *ibdev,
-					    u8 port_num)
+					    u32 port_num)
 {
 	return IB_LINK_LAYER_ETHERNET;
 }
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index 9a8130b79256..d68671cc6173 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -149,19 +149,19 @@ static inline u16 bnxt_re_get_rwqe_size(int nsge)
 int bnxt_re_query_device(struct ib_device *ibdev,
 			 struct ib_device_attr *ib_attr,
 			 struct ib_udata *udata);
-int bnxt_re_query_port(struct ib_device *ibdev, u8 port_num,
+int bnxt_re_query_port(struct ib_device *ibdev, u32 port_num,
 		       struct ib_port_attr *port_attr);
-int bnxt_re_get_port_immutable(struct ib_device *ibdev, u8 port_num,
+int bnxt_re_get_port_immutable(struct ib_device *ibdev, u32 port_num,
 			       struct ib_port_immutable *immutable);
 void bnxt_re_query_fw_str(struct ib_device *ibdev, char *str);
-int bnxt_re_query_pkey(struct ib_device *ibdev, u8 port_num,
+int bnxt_re_query_pkey(struct ib_device *ibdev, u32 port_num,
 		       u16 index, u16 *pkey);
 int bnxt_re_del_gid(const struct ib_gid_attr *attr, void **context);
 int bnxt_re_add_gid(const struct ib_gid_attr *attr, void **context);
-int bnxt_re_query_gid(struct ib_device *ibdev, u8 port_num,
+int bnxt_re_query_gid(struct ib_device *ibdev, u32 port_num,
 		      int index, union ib_gid *gid);
 enum rdma_link_layer bnxt_re_get_link_layer(struct ib_device *ibdev,
-					    u8 port_num);
+					    u32 port_num);
 int bnxt_re_alloc_pd(struct ib_pd *pd, struct ib_udata *udata);
 int bnxt_re_dealloc_pd(struct ib_pd *pd, struct ib_udata *udata);
 int bnxt_re_create_ah(struct ib_ah *ah, struct rdma_ah_init_attr *init_attr,
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 1f1f856f8715..3f1893e180dd 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -237,12 +237,12 @@ static int c4iw_allocate_pd(struct ib_pd *pd, struct ib_udata *udata)
 	return 0;
 }

-static int c4iw_query_gid(struct ib_device *ibdev, u8 port, int index,
+static int c4iw_query_gid(struct ib_device *ibdev, u32 port, int index,
 			  union ib_gid *gid)
 {
 	struct c4iw_dev *dev;

-	pr_debug("ibdev %p, port %d, index %d, gid %p\n",
+	pr_debug("ibdev %p, port %u, index %d, gid %p\n",
 		 ibdev, port, index, gid);
 	if (!port)
 		return -EINVAL;
@@ -295,7 +295,7 @@ static int c4iw_query_device(struct ib_device *ibdev, struct ib_device_attr *pro
 	return 0;
 }

-static int c4iw_query_port(struct ib_device *ibdev, u8 port,
+static int c4iw_query_port(struct ib_device *ibdev, u32 port,
 			   struct ib_port_attr *props)
 {
 	int ret = 0;
@@ -378,7 +378,7 @@ static const char * const names[] = {
 };

 static struct rdma_hw_stats *c4iw_alloc_stats(struct ib_device *ibdev,
-					      u8 port_num)
+					      u32 port_num)
 {
 	BUILD_BUG_ON(ARRAY_SIZE(names) != NR_COUNTERS);

@@ -391,7 +391,7 @@ static struct rdma_hw_stats *c4iw_alloc_stats(struct ib_device *ibdev,

 static int c4iw_get_mib(struct ib_device *ibdev,
 			struct rdma_hw_stats *stats,
-			u8 port, int index)
+			u32 port, int index)
 {
 	struct tp_tcp_stats v4, v6;
 	struct c4iw_dev *c4iw_dev = to_c4iw_dev(ibdev);
@@ -420,7 +420,7 @@ static const struct attribute_group c4iw_attr_group = {
 	.attrs = c4iw_class_attributes,
 };

-static int c4iw_port_immutable(struct ib_device *ibdev, u8 port_num,
+static int c4iw_port_immutable(struct ib_device *ibdev, u32 port_num,
 			       struct ib_port_immutable *immutable)
 {
 	struct ib_port_attr attr;
diff --git a/drivers/infiniband/hw/efa/efa.h b/drivers/infiniband/hw/efa/efa.h
index e5d9712e98c4..ea322cec27d2 100644
--- a/drivers/infiniband/hw/efa/efa.h
+++ b/drivers/infiniband/hw/efa/efa.h
@@ -120,14 +120,14 @@ struct efa_ah {
 int efa_query_device(struct ib_device *ibdev,
 		     struct ib_device_attr *props,
 		     struct ib_udata *udata);
-int efa_query_port(struct ib_device *ibdev, u8 port,
+int efa_query_port(struct ib_device *ibdev, u32 port,
 		   struct ib_port_attr *props);
 int efa_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 		 int qp_attr_mask,
 		 struct ib_qp_init_attr *qp_init_attr);
-int efa_query_gid(struct ib_device *ibdev, u8 port, int index,
+int efa_query_gid(struct ib_device *ibdev, u32 port, int index,
 		  union ib_gid *gid);
-int efa_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
+int efa_query_pkey(struct ib_device *ibdev, u32 port, u16 index,
 		   u16 *pkey);
 int efa_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata);
 int efa_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata);
@@ -142,7 +142,7 @@ struct ib_mr *efa_reg_mr(struct ib_pd *ibpd, u64 start, u64 length,
 			 u64 virt_addr, int access_flags,
 			 struct ib_udata *udata);
 int efa_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata);
-int efa_get_port_immutable(struct ib_device *ibdev, u8 port_num,
+int efa_get_port_immutable(struct ib_device *ibdev, u32 port_num,
 			   struct ib_port_immutable *immutable);
 int efa_alloc_ucontext(struct ib_ucontext *ibucontext, struct ib_udata *udata);
 void efa_dealloc_ucontext(struct ib_ucontext *ibucontext);
@@ -156,9 +156,9 @@ int efa_destroy_ah(struct ib_ah *ibah, u32 flags);
 int efa_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 		  int qp_attr_mask, struct ib_udata *udata);
 enum rdma_link_layer efa_port_link_layer(struct ib_device *ibdev,
-					 u8 port_num);
-struct rdma_hw_stats *efa_alloc_hw_stats(struct ib_device *ibdev, u8 port_num);
+					 u32 port_num);
+struct rdma_hw_stats *efa_alloc_hw_stats(struct ib_device *ibdev, u32 port_num);
 int efa_get_hw_stats(struct ib_device *ibdev, struct rdma_hw_stats *stats,
-		     u8 port_num, int index);
+		     u32 port_num, int index);

 #endif /* _EFA_H_ */
diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 479b604e533a..51572f1dc611 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -247,7 +247,7 @@ int efa_query_device(struct ib_device *ibdev,
 	return 0;
 }

-int efa_query_port(struct ib_device *ibdev, u8 port,
+int efa_query_port(struct ib_device *ibdev, u32 port,
 		   struct ib_port_attr *props)
 {
 	struct efa_dev *dev = to_edev(ibdev);
@@ -319,7 +319,7 @@ int efa_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 	return 0;
 }

-int efa_query_gid(struct ib_device *ibdev, u8 port, int index,
+int efa_query_gid(struct ib_device *ibdev, u32 port, int index,
 		  union ib_gid *gid)
 {
 	struct efa_dev *dev = to_edev(ibdev);
@@ -329,7 +329,7 @@ int efa_query_gid(struct ib_device *ibdev, u8 port, int index,
 	return 0;
 }

-int efa_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
+int efa_query_pkey(struct ib_device *ibdev, u32 port, u16 index,
 		   u16 *pkey)
 {
 	if (index > 0)
@@ -1619,7 +1619,7 @@ int efa_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 	return 0;
 }

-int efa_get_port_immutable(struct ib_device *ibdev, u8 port_num,
+int efa_get_port_immutable(struct ib_device *ibdev, u32 port_num,
 			   struct ib_port_immutable *immutable)
 {
 	struct ib_port_attr attr;
@@ -1904,7 +1904,7 @@ int efa_destroy_ah(struct ib_ah *ibah, u32 flags)
 	return 0;
 }

-struct rdma_hw_stats *efa_alloc_hw_stats(struct ib_device *ibdev, u8 port_num)
+struct rdma_hw_stats *efa_alloc_hw_stats(struct ib_device *ibdev, u32 port_num)
 {
 	return rdma_alloc_hw_stats_struct(efa_stats_names,
 					  ARRAY_SIZE(efa_stats_names),
@@ -1912,7 +1912,7 @@ struct rdma_hw_stats *efa_alloc_hw_stats(struct ib_device *ibdev, u8 port_num)
 }

 int efa_get_hw_stats(struct ib_device *ibdev, struct rdma_hw_stats *stats,
-		     u8 port_num, int index)
+		     u32 port_num, int index)
 {
 	struct efa_com_get_stats_params params = {};
 	union efa_com_get_stats_result result;
@@ -1981,7 +1981,7 @@ int efa_get_hw_stats(struct ib_device *ibdev, struct rdma_hw_stats *stats,
 }

 enum rdma_link_layer efa_port_link_layer(struct ib_device *ibdev,
-					 u8 port_num)
+					 u32 port_num)
 {
 	return IB_LINK_LAYER_UNSPECIFIED;
 }
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index e09e8244a94c..e17387e0e24c 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -864,7 +864,7 @@ struct hfi1_pportdata {
 	u8 rx_pol_inv;

 	u8 hw_pidx;     /* physical port index */
-	u8 port;        /* IB port number and index into dd->pports - 1 */
+	u32 port;        /* IB port number and index into dd->pports - 1 */
 	/* type of neighbor node */
 	u8 neighbor_type;
 	u8 neighbor_normal;
@@ -1479,7 +1479,7 @@ int hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, int numa,
 			 struct hfi1_ctxtdata **rcd);
 void hfi1_free_ctxt(struct hfi1_ctxtdata *rcd);
 void hfi1_init_pportdata(struct pci_dev *pdev, struct hfi1_pportdata *ppd,
-			 struct hfi1_devdata *dd, u8 hw_pidx, u8 port);
+			 struct hfi1_devdata *dd, u8 hw_pidx, u32 port);
 void hfi1_free_ctxtdata(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd);
 int hfi1_rcd_put(struct hfi1_ctxtdata *rcd);
 int hfi1_rcd_get(struct hfi1_ctxtdata *rcd);
@@ -1975,10 +1975,10 @@ static inline struct hfi1_ibdev *dev_from_rdi(struct rvt_dev_info *rdi)
 	return container_of(rdi, struct hfi1_ibdev, rdi);
 }

-static inline struct hfi1_ibport *to_iport(struct ib_device *ibdev, u8 port)
+static inline struct hfi1_ibport *to_iport(struct ib_device *ibdev, u32 port)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
-	unsigned pidx = port - 1; /* IB number port from 1, hdw from 0 */
+	u32 pidx = port - 1; /* IB number port from 1, hdw from 0 */

 	WARN_ON(pidx >= dd->num_pports);
 	return &dd->pport[pidx].ibport_data;
@@ -2197,7 +2197,7 @@ extern const struct attribute_group ib_hfi1_attr_group;
 int hfi1_device_create(struct hfi1_devdata *dd);
 void hfi1_device_remove(struct hfi1_devdata *dd);

-int hfi1_create_port_files(struct ib_device *ibdev, u8 port_num,
+int hfi1_create_port_files(struct ib_device *ibdev, u32 port_num,
 			   struct kobject *kobj);
 int hfi1_verbs_register_sysfs(struct hfi1_devdata *dd);
 void hfi1_verbs_unregister_sysfs(struct hfi1_devdata *dd);
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index cb7ad1288821..48e9c8af579a 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -627,7 +627,7 @@ static enum hrtimer_restart cca_timer_fn(struct hrtimer *t)
  * Common code for initializing the physical port structure.
  */
 void hfi1_init_pportdata(struct pci_dev *pdev, struct hfi1_pportdata *ppd,
-			 struct hfi1_devdata *dd, u8 hw_pidx, u8 port)
+			 struct hfi1_devdata *dd, u8 hw_pidx, u32 port)
 {
 	int i;
 	uint default_pkey_idx;
diff --git a/drivers/infiniband/hw/hfi1/ipoib.h b/drivers/infiniband/hw/hfi1/ipoib.h
index f650cac9d424..02c5b0d1ffc4 100644
--- a/drivers/infiniband/hw/hfi1/ipoib.h
+++ b/drivers/infiniband/hw/hfi1/ipoib.h
@@ -143,7 +143,7 @@ struct sk_buff *hfi1_ipoib_prepare_skb(struct hfi1_netdev_rxq *rxq,
 				       int size, void *data);

 int hfi1_ipoib_rn_get_params(struct ib_device *device,
-			     u8 port_num,
+			     u32 port_num,
 			     enum rdma_netdev_t type,
 			     struct rdma_netdev_alloc_params *params);

diff --git a/drivers/infiniband/hw/hfi1/ipoib_main.c b/drivers/infiniband/hw/hfi1/ipoib_main.c
index 3242290eb6a7..673dc754ea18 100644
--- a/drivers/infiniband/hw/hfi1/ipoib_main.c
+++ b/drivers/infiniband/hw/hfi1/ipoib_main.c
@@ -194,7 +194,7 @@ static void hfi1_ipoib_set_id(struct net_device *dev, int id)
 }

 static int hfi1_ipoib_setup_rn(struct ib_device *device,
-			       u8 port_num,
+			       u32 port_num,
 			       struct net_device *netdev,
 			       void *param)
 {
@@ -243,7 +243,7 @@ static int hfi1_ipoib_setup_rn(struct ib_device *device,
 }

 int hfi1_ipoib_rn_get_params(struct ib_device *device,
-			     u8 port_num,
+			     u32 port_num,
 			     enum rdma_netdev_t type,
 			     struct rdma_netdev_alloc_params *params)
 {
diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index e2f2f7847aed..1fe5e702f31d 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -108,7 +108,7 @@ static u16 hfi1_lookup_pkey_value(struct hfi1_ibport *ibp, int pkey_idx)
 	return 0;
 }

-void hfi1_event_pkey_change(struct hfi1_devdata *dd, u8 port)
+void hfi1_event_pkey_change(struct hfi1_devdata *dd, u32 port)
 {
 	struct ib_event event;

@@ -297,7 +297,7 @@ static struct ib_ah *hfi1_create_qp0_ah(struct hfi1_ibport *ibp, u32 dlid)
 	struct rvt_qp *qp0;
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 	struct hfi1_devdata *dd = dd_from_ppd(ppd);
-	u8 port_num = ppd->port;
+	u32 port_num = ppd->port;

 	memset(&attr, 0, sizeof(attr));
 	attr.type = rdma_ah_find_type(&dd->verbs_dev.rdi.ibdev, port_num);
@@ -515,7 +515,7 @@ static void bad_mkey(struct hfi1_ibport *ibp, struct ib_mad_hdr *mad,
 /*
  * Send a Port Capability Mask Changed trap (ch. 14.3.11).
  */
-void hfi1_cap_mask_chg(struct rvt_dev_info *rdi, u8 port_num)
+void hfi1_cap_mask_chg(struct rvt_dev_info *rdi, u32 port_num)
 {
 	struct trap_node *trap;
 	struct hfi1_ibdev *verbs_dev = dev_from_rdi(rdi);
@@ -581,7 +581,7 @@ void hfi1_node_desc_chg(struct hfi1_ibport *ibp)

 static int __subn_get_opa_nodedesc(struct opa_smp *smp, u32 am,
 				   u8 *data, struct ib_device *ibdev,
-				   u8 port, u32 *resp_len, u32 max_len)
+				   u32 port, u32 *resp_len, u32 max_len)
 {
 	struct opa_node_description *nd;

@@ -601,12 +601,12 @@ static int __subn_get_opa_nodedesc(struct opa_smp *smp, u32 am,
 }

 static int __subn_get_opa_nodeinfo(struct opa_smp *smp, u32 am, u8 *data,
-				   struct ib_device *ibdev, u8 port,
+				   struct ib_device *ibdev, u32 port,
 				   u32 *resp_len, u32 max_len)
 {
 	struct opa_node_info *ni;
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
-	unsigned pidx = port - 1; /* IB number port from 1, hw from 0 */
+	u32 pidx = port - 1; /* IB number port from 1, hw from 0 */

 	ni = (struct opa_node_info *)data;

@@ -641,11 +641,11 @@ static int __subn_get_opa_nodeinfo(struct opa_smp *smp, u32 am, u8 *data,
 }

 static int subn_get_nodeinfo(struct ib_smp *smp, struct ib_device *ibdev,
-			     u8 port)
+			     u32 port)
 {
 	struct ib_node_info *nip = (struct ib_node_info *)&smp->data;
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
-	unsigned pidx = port - 1; /* IB number port from 1, hw from 0 */
+	u32 pidx = port - 1; /* IB number port from 1, hw from 0 */

 	/* GUID 0 is illegal */
 	if (smp->attr_mod || pidx >= dd->num_pports ||
@@ -794,7 +794,7 @@ void read_ltp_rtt(struct hfi1_devdata *dd)
 }

 static int __subn_get_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
-				   struct ib_device *ibdev, u8 port,
+				   struct ib_device *ibdev, u32 port,
 				   u32 *resp_len, u32 max_len)
 {
 	int i;
@@ -1009,7 +1009,7 @@ static int __subn_get_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
  * @port: the IB port number
  * @pkeys: the pkey table is placed here
  */
-static int get_pkeys(struct hfi1_devdata *dd, u8 port, u16 *pkeys)
+static int get_pkeys(struct hfi1_devdata *dd, u32 port, u16 *pkeys)
 {
 	struct hfi1_pportdata *ppd = dd->pport + port - 1;

@@ -1019,7 +1019,7 @@ static int get_pkeys(struct hfi1_devdata *dd, u8 port, u16 *pkeys)
 }

 static int __subn_get_opa_pkeytable(struct opa_smp *smp, u32 am, u8 *data,
-				    struct ib_device *ibdev, u8 port,
+				    struct ib_device *ibdev, u32 port,
 				    u32 *resp_len, u32 max_len)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
@@ -1349,7 +1349,7 @@ static int set_port_states(struct hfi1_pportdata *ppd, struct opa_smp *smp,
  *
  */
 static int __subn_set_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
-				   struct ib_device *ibdev, u8 port,
+				   struct ib_device *ibdev, u32 port,
 				   u32 *resp_len, u32 max_len, int local_mad)
 {
 	struct opa_port_info *pi = (struct opa_port_info *)data;
@@ -1667,7 +1667,7 @@ static int __subn_set_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
  * @port: the IB port number
  * @pkeys: the PKEY table
  */
-static int set_pkeys(struct hfi1_devdata *dd, u8 port, u16 *pkeys)
+static int set_pkeys(struct hfi1_devdata *dd, u32 port, u16 *pkeys)
 {
 	struct hfi1_pportdata *ppd;
 	int i;
@@ -1718,7 +1718,7 @@ static int set_pkeys(struct hfi1_devdata *dd, u8 port, u16 *pkeys)
 }

 static int __subn_set_opa_pkeytable(struct opa_smp *smp, u32 am, u8 *data,
-				    struct ib_device *ibdev, u8 port,
+				    struct ib_device *ibdev, u32 port,
 				    u32 *resp_len, u32 max_len)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
@@ -1732,7 +1732,7 @@ static int __subn_set_opa_pkeytable(struct opa_smp *smp, u32 am, u8 *data,
 	u32 size = 0;

 	if (n_blocks_sent == 0) {
-		pr_warn("OPA Get PKey AM Invalid : P = %d; B = 0x%x; N = 0x%x\n",
+		pr_warn("OPA Get PKey AM Invalid : P = %u; B = 0x%x; N = 0x%x\n",
 			port, start_block, n_blocks_sent);
 		smp->status |= IB_SMP_INVALID_FIELD;
 		return reply((struct ib_mad_hdr *)smp);
@@ -1825,7 +1825,7 @@ static int get_sc2vlt_tables(struct hfi1_devdata *dd, void *data)
 }

 static int __subn_get_opa_sl_to_sc(struct opa_smp *smp, u32 am, u8 *data,
-				   struct ib_device *ibdev, u8 port,
+				   struct ib_device *ibdev, u32 port,
 				   u32 *resp_len, u32 max_len)
 {
 	struct hfi1_ibport *ibp = to_iport(ibdev, port);
@@ -1848,7 +1848,7 @@ static int __subn_get_opa_sl_to_sc(struct opa_smp *smp, u32 am, u8 *data,
 }

 static int __subn_set_opa_sl_to_sc(struct opa_smp *smp, u32 am, u8 *data,
-				   struct ib_device *ibdev, u8 port,
+				   struct ib_device *ibdev, u32 port,
 				   u32 *resp_len, u32 max_len)
 {
 	struct hfi1_ibport *ibp = to_iport(ibdev, port);
@@ -1877,7 +1877,7 @@ static int __subn_set_opa_sl_to_sc(struct opa_smp *smp, u32 am, u8 *data,
 }

 static int __subn_get_opa_sc_to_sl(struct opa_smp *smp, u32 am, u8 *data,
-				   struct ib_device *ibdev, u8 port,
+				   struct ib_device *ibdev, u32 port,
 				   u32 *resp_len, u32 max_len)
 {
 	struct hfi1_ibport *ibp = to_iport(ibdev, port);
@@ -1900,7 +1900,7 @@ static int __subn_get_opa_sc_to_sl(struct opa_smp *smp, u32 am, u8 *data,
 }

 static int __subn_set_opa_sc_to_sl(struct opa_smp *smp, u32 am, u8 *data,
-				   struct ib_device *ibdev, u8 port,
+				   struct ib_device *ibdev, u32 port,
 				   u32 *resp_len, u32 max_len)
 {
 	struct hfi1_ibport *ibp = to_iport(ibdev, port);
@@ -1921,7 +1921,7 @@ static int __subn_set_opa_sc_to_sl(struct opa_smp *smp, u32 am, u8 *data,
 }

 static int __subn_get_opa_sc_to_vlt(struct opa_smp *smp, u32 am, u8 *data,
-				    struct ib_device *ibdev, u8 port,
+				    struct ib_device *ibdev, u32 port,
 				    u32 *resp_len, u32 max_len)
 {
 	u32 n_blocks = OPA_AM_NBLK(am);
@@ -1943,7 +1943,7 @@ static int __subn_get_opa_sc_to_vlt(struct opa_smp *smp, u32 am, u8 *data,
 }

 static int __subn_set_opa_sc_to_vlt(struct opa_smp *smp, u32 am, u8 *data,
-				    struct ib_device *ibdev, u8 port,
+				    struct ib_device *ibdev, u32 port,
 				    u32 *resp_len, u32 max_len)
 {
 	u32 n_blocks = OPA_AM_NBLK(am);
@@ -1985,7 +1985,7 @@ static int __subn_set_opa_sc_to_vlt(struct opa_smp *smp, u32 am, u8 *data,
 }

 static int __subn_get_opa_sc_to_vlnt(struct opa_smp *smp, u32 am, u8 *data,
-				     struct ib_device *ibdev, u8 port,
+				     struct ib_device *ibdev, u32 port,
 				     u32 *resp_len, u32 max_len)
 {
 	u32 n_blocks = OPA_AM_NPORT(am);
@@ -2010,7 +2010,7 @@ static int __subn_get_opa_sc_to_vlnt(struct opa_smp *smp, u32 am, u8 *data,
 }

 static int __subn_set_opa_sc_to_vlnt(struct opa_smp *smp, u32 am, u8 *data,
-				     struct ib_device *ibdev, u8 port,
+				     struct ib_device *ibdev, u32 port,
 				     u32 *resp_len, u32 max_len)
 {
 	u32 n_blocks = OPA_AM_NPORT(am);
@@ -2042,7 +2042,7 @@ static int __subn_set_opa_sc_to_vlnt(struct opa_smp *smp, u32 am, u8 *data,
 }

 static int __subn_get_opa_psi(struct opa_smp *smp, u32 am, u8 *data,
-			      struct ib_device *ibdev, u8 port,
+			      struct ib_device *ibdev, u32 port,
 			      u32 *resp_len, u32 max_len)
 {
 	u32 nports = OPA_AM_NPORT(am);
@@ -2084,7 +2084,7 @@ static int __subn_get_opa_psi(struct opa_smp *smp, u32 am, u8 *data,
 }

 static int __subn_set_opa_psi(struct opa_smp *smp, u32 am, u8 *data,
-			      struct ib_device *ibdev, u8 port,
+			      struct ib_device *ibdev, u32 port,
 			      u32 *resp_len, u32 max_len, int local_mad)
 {
 	u32 nports = OPA_AM_NPORT(am);
@@ -2132,7 +2132,7 @@ static int __subn_set_opa_psi(struct opa_smp *smp, u32 am, u8 *data,
 }

 static int __subn_get_opa_cable_info(struct opa_smp *smp, u32 am, u8 *data,
-				     struct ib_device *ibdev, u8 port,
+				     struct ib_device *ibdev, u32 port,
 				     u32 *resp_len, u32 max_len)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
@@ -2184,7 +2184,7 @@ static int __subn_get_opa_cable_info(struct opa_smp *smp, u32 am, u8 *data,
 }

 static int __subn_get_opa_bct(struct opa_smp *smp, u32 am, u8 *data,
-			      struct ib_device *ibdev, u8 port, u32 *resp_len,
+			      struct ib_device *ibdev, u32 port, u32 *resp_len,
 			      u32 max_len)
 {
 	u32 num_ports = OPA_AM_NPORT(am);
@@ -2208,7 +2208,7 @@ static int __subn_get_opa_bct(struct opa_smp *smp, u32 am, u8 *data,
 }

 static int __subn_set_opa_bct(struct opa_smp *smp, u32 am, u8 *data,
-			      struct ib_device *ibdev, u8 port, u32 *resp_len,
+			      struct ib_device *ibdev, u32 port, u32 *resp_len,
 			      u32 max_len)
 {
 	u32 num_ports = OPA_AM_NPORT(am);
@@ -2232,7 +2232,7 @@ static int __subn_set_opa_bct(struct opa_smp *smp, u32 am, u8 *data,
 }

 static int __subn_get_opa_vl_arb(struct opa_smp *smp, u32 am, u8 *data,
-				 struct ib_device *ibdev, u8 port,
+				 struct ib_device *ibdev, u32 port,
 				 u32 *resp_len, u32 max_len)
 {
 	struct hfi1_pportdata *ppd = ppd_from_ibp(to_iport(ibdev, port));
@@ -2274,7 +2274,7 @@ static int __subn_get_opa_vl_arb(struct opa_smp *smp, u32 am, u8 *data,
 }

 static int __subn_set_opa_vl_arb(struct opa_smp *smp, u32 am, u8 *data,
-				 struct ib_device *ibdev, u8 port,
+				 struct ib_device *ibdev, u32 port,
 				 u32 *resp_len, u32 max_len)
 {
 	struct hfi1_pportdata *ppd = ppd_from_ibp(to_iport(ibdev, port));
@@ -2722,7 +2722,7 @@ u64 get_xmit_wait_counters(struct hfi1_pportdata *ppd,

 static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
 				  struct ib_device *ibdev,
-				  u8 port, u32 *resp_len)
+				  u32 port, u32 *resp_len)
 {
 	struct opa_port_status_req *req =
 		(struct opa_port_status_req *)pmp->data;
@@ -2732,7 +2732,7 @@ static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
 	unsigned long vl;
 	size_t response_data_size;
 	u32 nports = be32_to_cpu(pmp->mad_hdr.attr_mod) >> 24;
-	u8 port_num = req->port_num;
+	u32 port_num = req->port_num;
 	u8 num_vls = hweight64(vl_select_mask);
 	struct _vls_pctrs *vlinfo;
 	struct hfi1_ibport *ibp = to_iport(ibdev, port);
@@ -2888,7 +2888,7 @@ static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
 	return reply((struct ib_mad_hdr *)pmp);
 }

-static u64 get_error_counter_summary(struct ib_device *ibdev, u8 port,
+static u64 get_error_counter_summary(struct ib_device *ibdev, u32 port,
 				     u8 res_lli, u8 res_ler)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
@@ -2973,7 +2973,7 @@ static void pma_get_opa_port_dctrs(struct ib_device *ibdev,

 static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 				    struct ib_device *ibdev,
-				    u8 port, u32 *resp_len)
+				    u32 port, u32 *resp_len)
 {
 	struct opa_port_data_counters_msg *req =
 		(struct opa_port_data_counters_msg *)pmp->data;
@@ -2987,7 +2987,7 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 	u8 lq, num_vls;
 	u8 res_lli, res_ler;
 	u64 port_mask;
-	u8 port_num;
+	u32 port_num;
 	unsigned long vl;
 	unsigned long vl_select_mask;
 	int vfi;
@@ -3123,7 +3123,7 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 }

 static int pma_get_ib_portcounters_ext(struct ib_pma_mad *pmp,
-				       struct ib_device *ibdev, u8 port)
+				       struct ib_device *ibdev, u32 port)
 {
 	struct ib_pma_portcounters_ext *p = (struct ib_pma_portcounters_ext *)
 						pmp->data;
@@ -3151,7 +3151,7 @@ static int pma_get_ib_portcounters_ext(struct ib_pma_mad *pmp,
 }

 static void pma_get_opa_port_ectrs(struct ib_device *ibdev,
-				   struct _port_ectrs *rsp, u8 port)
+				   struct _port_ectrs *rsp, u32 port)
 {
 	u64 tmp, tmp2;
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
@@ -3194,11 +3194,11 @@ static void pma_get_opa_port_ectrs(struct ib_device *ibdev,

 static int pma_get_opa_porterrors(struct opa_pma_mad *pmp,
 				  struct ib_device *ibdev,
-				  u8 port, u32 *resp_len)
+				  u32 port, u32 *resp_len)
 {
 	size_t response_data_size;
 	struct _port_ectrs *rsp;
-	u8 port_num;
+	u32 port_num;
 	struct opa_port_error_counters64_msg *req;
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
 	u32 num_ports;
@@ -3283,7 +3283,7 @@ static int pma_get_opa_porterrors(struct opa_pma_mad *pmp,
 }

 static int pma_get_ib_portcounters(struct ib_pma_mad *pmp,
-				   struct ib_device *ibdev, u8 port)
+				   struct ib_device *ibdev, u32 port)
 {
 	struct ib_pma_portcounters *p = (struct ib_pma_portcounters *)
 		pmp->data;
@@ -3369,7 +3369,7 @@ static int pma_get_ib_portcounters(struct ib_pma_mad *pmp,

 static int pma_get_opa_errorinfo(struct opa_pma_mad *pmp,
 				 struct ib_device *ibdev,
-				 u8 port, u32 *resp_len)
+				 u32 port, u32 *resp_len)
 {
 	size_t response_data_size;
 	struct _port_ei *rsp;
@@ -3377,7 +3377,7 @@ static int pma_get_opa_errorinfo(struct opa_pma_mad *pmp,
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
 	u64 port_mask;
 	u32 num_ports;
-	u8 port_num;
+	u32 port_num;
 	u8 num_pslm;
 	u64 reg;

@@ -3468,7 +3468,7 @@ static int pma_get_opa_errorinfo(struct opa_pma_mad *pmp,

 static int pma_set_opa_portstatus(struct opa_pma_mad *pmp,
 				  struct ib_device *ibdev,
-				  u8 port, u32 *resp_len)
+				  u32 port, u32 *resp_len)
 {
 	struct opa_clear_port_status *req =
 		(struct opa_clear_port_status *)pmp->data;
@@ -3620,14 +3620,14 @@ static int pma_set_opa_portstatus(struct opa_pma_mad *pmp,

 static int pma_set_opa_errorinfo(struct opa_pma_mad *pmp,
 				 struct ib_device *ibdev,
-				 u8 port, u32 *resp_len)
+				 u32 port, u32 *resp_len)
 {
 	struct _port_ei *rsp;
 	struct opa_port_error_info_msg *req;
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
 	u64 port_mask;
 	u32 num_ports;
-	u8 port_num;
+	u32 port_num;
 	u8 num_pslm;
 	u32 error_info_select;

@@ -3702,7 +3702,7 @@ struct opa_congestion_info_attr {
 } __packed;

 static int __subn_get_opa_cong_info(struct opa_smp *smp, u32 am, u8 *data,
-				    struct ib_device *ibdev, u8 port,
+				    struct ib_device *ibdev, u32 port,
 				    u32 *resp_len, u32 max_len)
 {
 	struct opa_congestion_info_attr *p =
@@ -3727,7 +3727,7 @@ static int __subn_get_opa_cong_info(struct opa_smp *smp, u32 am, u8 *data,

 static int __subn_get_opa_cong_setting(struct opa_smp *smp, u32 am,
 				       u8 *data, struct ib_device *ibdev,
-				       u8 port, u32 *resp_len, u32 max_len)
+				       u32 port, u32 *resp_len, u32 max_len)
 {
 	int i;
 	struct opa_congestion_setting_attr *p =
@@ -3819,7 +3819,7 @@ static void apply_cc_state(struct hfi1_pportdata *ppd)
 }

 static int __subn_set_opa_cong_setting(struct opa_smp *smp, u32 am, u8 *data,
-				       struct ib_device *ibdev, u8 port,
+				       struct ib_device *ibdev, u32 port,
 				       u32 *resp_len, u32 max_len)
 {
 	struct opa_congestion_setting_attr *p =
@@ -3860,7 +3860,7 @@ static int __subn_set_opa_cong_setting(struct opa_smp *smp, u32 am, u8 *data,

 static int __subn_get_opa_hfi1_cong_log(struct opa_smp *smp, u32 am,
 					u8 *data, struct ib_device *ibdev,
-					u8 port, u32 *resp_len, u32 max_len)
+					u32 port, u32 *resp_len, u32 max_len)
 {
 	struct hfi1_ibport *ibp = to_iport(ibdev, port);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
@@ -3925,7 +3925,7 @@ static int __subn_get_opa_hfi1_cong_log(struct opa_smp *smp, u32 am,
 }

 static int __subn_get_opa_cc_table(struct opa_smp *smp, u32 am, u8 *data,
-				   struct ib_device *ibdev, u8 port,
+				   struct ib_device *ibdev, u32 port,
 				   u32 *resp_len, u32 max_len)
 {
 	struct ib_cc_table_attr *cc_table_attr =
@@ -3977,7 +3977,7 @@ static int __subn_get_opa_cc_table(struct opa_smp *smp, u32 am, u8 *data,
 }

 static int __subn_set_opa_cc_table(struct opa_smp *smp, u32 am, u8 *data,
-				   struct ib_device *ibdev, u8 port,
+				   struct ib_device *ibdev, u32 port,
 				   u32 *resp_len, u32 max_len)
 {
 	struct ib_cc_table_attr *p = (struct ib_cc_table_attr *)data;
@@ -4036,7 +4036,7 @@ struct opa_led_info {
 #define OPA_LED_MASK	BIT(OPA_LED_SHIFT)

 static int __subn_get_opa_led_info(struct opa_smp *smp, u32 am, u8 *data,
-				   struct ib_device *ibdev, u8 port,
+				   struct ib_device *ibdev, u32 port,
 				   u32 *resp_len, u32 max_len)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
@@ -4066,7 +4066,7 @@ static int __subn_get_opa_led_info(struct opa_smp *smp, u32 am, u8 *data,
 }

 static int __subn_set_opa_led_info(struct opa_smp *smp, u32 am, u8 *data,
-				   struct ib_device *ibdev, u8 port,
+				   struct ib_device *ibdev, u32 port,
 				   u32 *resp_len, u32 max_len)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
@@ -4089,7 +4089,7 @@ static int __subn_set_opa_led_info(struct opa_smp *smp, u32 am, u8 *data,
 }

 static int subn_get_opa_sma(__be16 attr_id, struct opa_smp *smp, u32 am,
-			    u8 *data, struct ib_device *ibdev, u8 port,
+			    u8 *data, struct ib_device *ibdev, u32 port,
 			    u32 *resp_len, u32 max_len)
 {
 	int ret;
@@ -4179,7 +4179,7 @@ static int subn_get_opa_sma(__be16 attr_id, struct opa_smp *smp, u32 am,
 }

 static int subn_set_opa_sma(__be16 attr_id, struct opa_smp *smp, u32 am,
-			    u8 *data, struct ib_device *ibdev, u8 port,
+			    u8 *data, struct ib_device *ibdev, u32 port,
 			    u32 *resp_len, u32 max_len, int local_mad)
 {
 	int ret;
@@ -4254,7 +4254,7 @@ static inline void set_aggr_error(struct opa_aggregate *ag)
 }

 static int subn_get_opa_aggregate(struct opa_smp *smp,
-				  struct ib_device *ibdev, u8 port,
+				  struct ib_device *ibdev, u32 port,
 				  u32 *resp_len)
 {
 	int i;
@@ -4303,7 +4303,7 @@ static int subn_get_opa_aggregate(struct opa_smp *smp,
 }

 static int subn_set_opa_aggregate(struct opa_smp *smp,
-				  struct ib_device *ibdev, u8 port,
+				  struct ib_device *ibdev, u32 port,
 				  u32 *resp_len, int local_mad)
 {
 	int i;
@@ -4509,7 +4509,7 @@ static int hfi1_pkey_validation_pma(struct hfi1_ibport *ibp,
 }

 static int process_subn_opa(struct ib_device *ibdev, int mad_flags,
-			    u8 port, const struct opa_mad *in_mad,
+			    u32 port, const struct opa_mad *in_mad,
 			    struct opa_mad *out_mad,
 			    u32 *resp_len, int local_mad)
 {
@@ -4614,7 +4614,7 @@ static int process_subn_opa(struct ib_device *ibdev, int mad_flags,
 }

 static int process_subn(struct ib_device *ibdev, int mad_flags,
-			u8 port, const struct ib_mad *in_mad,
+			u32 port, const struct ib_mad *in_mad,
 			struct ib_mad *out_mad)
 {
 	struct ib_smp *smp = (struct ib_smp *)out_mad;
@@ -4672,7 +4672,7 @@ static int process_subn(struct ib_device *ibdev, int mad_flags,
 	return ret;
 }

-static int process_perf(struct ib_device *ibdev, u8 port,
+static int process_perf(struct ib_device *ibdev, u32 port,
 			const struct ib_mad *in_mad,
 			struct ib_mad *out_mad)
 {
@@ -4734,7 +4734,7 @@ static int process_perf(struct ib_device *ibdev, u8 port,
 	return ret;
 }

-static int process_perf_opa(struct ib_device *ibdev, u8 port,
+static int process_perf_opa(struct ib_device *ibdev, u32 port,
 			    const struct opa_mad *in_mad,
 			    struct opa_mad *out_mad, u32 *resp_len)
 {
@@ -4816,7 +4816,7 @@ static int process_perf_opa(struct ib_device *ibdev, u8 port,
 }

 static int hfi1_process_opa_mad(struct ib_device *ibdev, int mad_flags,
-				u8 port, const struct ib_wc *in_wc,
+				u32 port, const struct ib_wc *in_wc,
 				const struct ib_grh *in_grh,
 				const struct opa_mad *in_mad,
 				struct opa_mad *out_mad, size_t *out_mad_size,
@@ -4869,7 +4869,7 @@ static int hfi1_process_opa_mad(struct ib_device *ibdev, int mad_flags,
 	return ret;
 }

-static int hfi1_process_ib_mad(struct ib_device *ibdev, int mad_flags, u8 port,
+static int hfi1_process_ib_mad(struct ib_device *ibdev, int mad_flags, u32 port,
 			       const struct ib_wc *in_wc,
 			       const struct ib_grh *in_grh,
 			       const struct ib_mad *in_mad,
@@ -4914,7 +4914,7 @@ static int hfi1_process_ib_mad(struct ib_device *ibdev, int mad_flags, u8 port,
  *
  * This is called by the ib_mad module.
  */
-int hfi1_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
+int hfi1_process_mad(struct ib_device *ibdev, int mad_flags, u32 port,
 		     const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 		     const struct ib_mad *in_mad, struct ib_mad *out_mad,
 		     size_t *out_mad_size, u16 *out_mad_pkey_index)
diff --git a/drivers/infiniband/hw/hfi1/mad.h b/drivers/infiniband/hw/hfi1/mad.h
index 889e63d3f2cc..0205d308ef5e 100644
--- a/drivers/infiniband/hw/hfi1/mad.h
+++ b/drivers/infiniband/hw/hfi1/mad.h
@@ -436,7 +436,7 @@ struct sc2vlnt {
 		    COUNTER_MASK(1, 3) | \
 		    COUNTER_MASK(1, 4))

-void hfi1_event_pkey_change(struct hfi1_devdata *dd, u8 port);
+void hfi1_event_pkey_change(struct hfi1_devdata *dd, u32 port);
 void hfi1_handle_trap_timer(struct timer_list *t);
 u16 tx_link_width(u16 link_width);
 u64 get_xmit_wait_counters(struct hfi1_pportdata *ppd, u16 link_width,
diff --git a/drivers/infiniband/hw/hfi1/sysfs.c b/drivers/infiniband/hw/hfi1/sysfs.c
index 5650130e68d4..eaf441ece25e 100644
--- a/drivers/infiniband/hw/hfi1/sysfs.c
+++ b/drivers/infiniband/hw/hfi1/sysfs.c
@@ -649,7 +649,7 @@ const struct attribute_group ib_hfi1_attr_group = {
 	.attrs = hfi1_attributes,
 };

-int hfi1_create_port_files(struct ib_device *ibdev, u8 port_num,
+int hfi1_create_port_files(struct ib_device *ibdev, u32 port_num,
 			   struct kobject *kobj)
 {
 	struct hfi1_pportdata *ppd;
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 0dd4bb0a5a7e..554294340caa 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1407,7 +1407,7 @@ static inline u16 opa_width_to_ib(u16 in)
 	}
 }

-static int query_port(struct rvt_dev_info *rdi, u8 port_num,
+static int query_port(struct rvt_dev_info *rdi, u32 port_num,
 		      struct ib_port_attr *props)
 {
 	struct hfi1_ibdev *verbs_dev = dev_from_rdi(rdi);
@@ -1485,7 +1485,7 @@ static int modify_device(struct ib_device *device,
 	return ret;
 }

-static int shut_down_port(struct rvt_dev_info *rdi, u8 port_num)
+static int shut_down_port(struct rvt_dev_info *rdi, u32 port_num)
 {
 	struct hfi1_ibdev *verbs_dev = dev_from_rdi(rdi);
 	struct hfi1_devdata *dd = dd_from_dev(verbs_dev);
@@ -1694,7 +1694,7 @@ static int init_cntr_names(const char *names_in,
 }

 static struct rdma_hw_stats *alloc_hw_stats(struct ib_device *ibdev,
-					    u8 port_num)
+					    u32 port_num)
 {
 	int i, err;

@@ -1758,7 +1758,7 @@ static u64 hfi1_sps_ints(void)
 }

 static int get_hw_stats(struct ib_device *ibdev, struct rdma_hw_stats *stats,
-			u8 port, int index)
+			u32 port, int index)
 {
 	u64 *values;
 	int count;
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index d36e3e14896d..420df17cd184 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -325,10 +325,10 @@ static inline struct rvt_qp *iowait_to_qp(struct iowait *s_iowait)
  */
 void hfi1_bad_pkey(struct hfi1_ibport *ibp, u32 key, u32 sl,
 		   u32 qp1, u32 qp2, u32 lid1, u32 lid2);
-void hfi1_cap_mask_chg(struct rvt_dev_info *rdi, u8 port_num);
+void hfi1_cap_mask_chg(struct rvt_dev_info *rdi, u32 port_num);
 void hfi1_sys_guid_chg(struct hfi1_ibport *ibp);
 void hfi1_node_desc_chg(struct hfi1_ibport *ibp);
-int hfi1_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
+int hfi1_process_mad(struct ib_device *ibdev, int mad_flags, u32 port,
 		     const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 		     const struct ib_mad *in_mad, struct ib_mad *out_mad,
 		     size_t *out_mad_size, u16 *out_mad_pkey_index);
diff --git a/drivers/infiniband/hw/hfi1/vnic.h b/drivers/infiniband/hw/hfi1/vnic.h
index 66150a13f374..a7a450e2cf2c 100644
--- a/drivers/infiniband/hw/hfi1/vnic.h
+++ b/drivers/infiniband/hw/hfi1/vnic.h
@@ -156,7 +156,7 @@ bool hfi1_vnic_sdma_write_avail(struct hfi1_vnic_vport_info *vinfo,

 /* vnic rdma netdev operations */
 struct net_device *hfi1_vnic_alloc_rn(struct ib_device *device,
-				      u8 port_num,
+				      u32 port_num,
 				      enum rdma_netdev_t type,
 				      const char *name,
 				      unsigned char name_assign_type,
diff --git a/drivers/infiniband/hw/hfi1/vnic_main.c b/drivers/infiniband/hw/hfi1/vnic_main.c
index a90824de0f57..7e79c0578ecf 100644
--- a/drivers/infiniband/hw/hfi1/vnic_main.c
+++ b/drivers/infiniband/hw/hfi1/vnic_main.c
@@ -593,7 +593,7 @@ static void hfi1_vnic_free_rn(struct net_device *netdev)
 }

 struct net_device *hfi1_vnic_alloc_rn(struct ib_device *device,
-				      u8 port_num,
+				      u32 port_num,
 				      enum rdma_netdev_t type,
 				      const char *name,
 				      unsigned char name_assign_type,
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 3d6b7a2db496..c9b4c6c5e8e8 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -876,7 +876,7 @@ struct hns_roce_hw {
 			 u16 token, int event);
 	int (*chk_mbox)(struct hns_roce_dev *hr_dev, unsigned int timeout);
 	int (*rst_prc_mbox)(struct hns_roce_dev *hr_dev);
-	int (*set_gid)(struct hns_roce_dev *hr_dev, u8 port, int gid_index,
+	int (*set_gid)(struct hns_roce_dev *hr_dev, u32 port, int gid_index,
 		       const union ib_gid *gid, const struct ib_gid_attr *attr);
 	int (*set_mac)(struct hns_roce_dev *hr_dev, u8 phy_port, u8 *addr);
 	void (*set_mtu)(struct hns_roce_dev *hr_dev, u8 phy_port,
@@ -1246,7 +1246,7 @@ void hns_roce_cq_completion(struct hns_roce_dev *hr_dev, u32 cqn);
 void hns_roce_cq_event(struct hns_roce_dev *hr_dev, u32 cqn, int event_type);
 void hns_roce_qp_event(struct hns_roce_dev *hr_dev, u32 qpn, int event_type);
 void hns_roce_srq_event(struct hns_roce_dev *hr_dev, u32 srqn, int event_type);
-u8 hns_get_gid_index(struct hns_roce_dev *hr_dev, u8 port, int gid_index);
+u8 hns_get_gid_index(struct hns_roce_dev *hr_dev, u32 port, int gid_index);
 void hns_roce_handle_device_err(struct hns_roce_dev *hr_dev);
 int hns_roce_init(struct hns_roce_dev *hr_dev);
 void hns_roce_exit(struct hns_roce_dev *hr_dev);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 5346fdca9473..759ffe52567a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -54,7 +54,7 @@
  *		GID[0][0], GID[1][0],.....GID[N - 1][0],
  *		And so on
  */
-u8 hns_get_gid_index(struct hns_roce_dev *hr_dev, u8 port, int gid_index)
+u8 hns_get_gid_index(struct hns_roce_dev *hr_dev, u32 port, int gid_index)
 {
 	return gid_index * hr_dev->caps.num_ports + port;
 }
@@ -711,7 +711,7 @@ static int hns_roce_v1_rsv_lp_qp(struct hns_roce_dev *hr_dev)
 	int i, j;
 	u8 queue_en[HNS_ROCE_V1_RESV_QP] = { 0 };
 	u8 phy_port;
-	u8 port = 0;
+	u32 port = 0;
 	u8 sl;

 	/* Reserved cq for loop qp */
@@ -1676,7 +1676,7 @@ static int hns_roce_v1_chk_mbox(struct hns_roce_dev *hr_dev,
 	return 0;
 }

-static int hns_roce_v1_set_gid(struct hns_roce_dev *hr_dev, u8 port,
+static int hns_roce_v1_set_gid(struct hns_roce_dev *hr_dev, u32 port,
 			       int gid_index, const union ib_gid *gid,
 			       const struct ib_gid_attr *attr)
 {
@@ -2673,8 +2673,8 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 	int ret = -EINVAL;
 	u64 sq_ba = 0;
 	u64 rq_ba = 0;
-	int port;
-	u8 port_num;
+	u32 port;
+	u32 port_num;
 	u8 *dmac;
 	u8 *smac;

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index c3934abeb260..4bde8c5f63c4 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2788,7 +2788,7 @@ static int config_gmv_table(struct hns_roce_dev *hr_dev,
 	return hns_roce_cmq_send(hr_dev, desc, 2);
 }

-static int hns_roce_v2_set_gid(struct hns_roce_dev *hr_dev, u8 port,
+static int hns_roce_v2_set_gid(struct hns_roce_dev *hr_dev, u32 port,
 			       int gid_index, const union ib_gid *gid,
 			       const struct ib_gid_attr *attr)
 {
@@ -4238,7 +4238,7 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 	u64 *mtts;
 	u8 *dmac;
 	u8 *smac;
-	int port;
+	u32 port;
 	int ret;

 	ret = config_qp_rq_buf(hr_dev, hr_qp, context, qpc_mask);
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index c9c0836394a2..ffb37c89682b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -42,7 +42,7 @@
 #include "hns_roce_device.h"
 #include "hns_roce_hem.h"

-static int hns_roce_set_mac(struct hns_roce_dev *hr_dev, u8 port, u8 *addr)
+static int hns_roce_set_mac(struct hns_roce_dev *hr_dev, u32 port, u8 *addr)
 {
 	u8 phy_port;
 	u32 i;
@@ -63,7 +63,7 @@ static int hns_roce_set_mac(struct hns_roce_dev *hr_dev, u8 port, u8 *addr)
 static int hns_roce_add_gid(const struct ib_gid_attr *attr, void **context)
 {
 	struct hns_roce_dev *hr_dev = to_hr_dev(attr->device);
-	u8 port = attr->port_num - 1;
+	u32 port = attr->port_num - 1;
 	int ret;

 	if (port >= hr_dev->caps.num_ports)
@@ -77,7 +77,7 @@ static int hns_roce_add_gid(const struct ib_gid_attr *attr, void **context)
 static int hns_roce_del_gid(const struct ib_gid_attr *attr, void **context)
 {
 	struct hns_roce_dev *hr_dev = to_hr_dev(attr->device);
-	u8 port = attr->port_num - 1;
+	u32 port = attr->port_num - 1;
 	int ret;

 	if (port >= hr_dev->caps.num_ports)
@@ -88,7 +88,7 @@ static int hns_roce_del_gid(const struct ib_gid_attr *attr, void **context)
 	return ret;
 }

-static int handle_en_event(struct hns_roce_dev *hr_dev, u8 port,
+static int handle_en_event(struct hns_roce_dev *hr_dev, u32 port,
 			   unsigned long event)
 {
 	struct device *dev = hr_dev->dev;
@@ -128,7 +128,7 @@ static int hns_roce_netdev_event(struct notifier_block *self,
 	struct hns_roce_ib_iboe *iboe = NULL;
 	struct hns_roce_dev *hr_dev = NULL;
 	int ret;
-	u8 port;
+	u32 port;

 	hr_dev = container_of(self, struct hns_roce_dev, iboe.nb);
 	iboe = &hr_dev->iboe;
@@ -210,7 +210,7 @@ static int hns_roce_query_device(struct ib_device *ib_dev,
 	return 0;
 }

-static int hns_roce_query_port(struct ib_device *ib_dev, u8 port_num,
+static int hns_roce_query_port(struct ib_device *ib_dev, u32 port_num,
 			       struct ib_port_attr *props)
 {
 	struct hns_roce_dev *hr_dev = to_hr_dev(ib_dev);
@@ -218,7 +218,7 @@ static int hns_roce_query_port(struct ib_device *ib_dev, u8 port_num,
 	struct net_device *net_dev;
 	unsigned long flags;
 	enum ib_mtu mtu;
-	u8 port;
+	u32 port;

 	port = port_num - 1;

@@ -258,12 +258,12 @@ static int hns_roce_query_port(struct ib_device *ib_dev, u8 port_num,
 }

 static enum rdma_link_layer hns_roce_get_link_layer(struct ib_device *device,
-						    u8 port_num)
+						    u32 port_num)
 {
 	return IB_LINK_LAYER_ETHERNET;
 }

-static int hns_roce_query_pkey(struct ib_device *ib_dev, u8 port, u16 index,
+static int hns_roce_query_pkey(struct ib_device *ib_dev, u32 port, u16 index,
 			       u16 *pkey)
 {
 	*pkey = PKEY_ID;
@@ -365,7 +365,7 @@ static int hns_roce_mmap(struct ib_ucontext *context,
 	}
 }

-static int hns_roce_port_immutable(struct ib_device *ib_dev, u8 port_num,
+static int hns_roce_port_immutable(struct ib_device *ib_dev, u32 port_num,
 				   struct ib_port_immutable *immutable)
 {
 	struct ib_port_attr attr;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index f18d146a6079..1a88a9e2a785 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -94,7 +94,7 @@ static int i40iw_query_device(struct ib_device *ibdev,
  * @props: returning device attributes
  */
 static int i40iw_query_port(struct ib_device *ibdev,
-			    u8 port,
+			    u32 port,
 			    struct ib_port_attr *props)
 {
 	props->lid = 1;
@@ -2347,7 +2347,7 @@ static int i40iw_req_notify_cq(struct ib_cq *ibcq,
  * @port_num: port number
  * @immutable: immutable data for the port return
  */
-static int i40iw_port_immutable(struct ib_device *ibdev, u8 port_num,
+static int i40iw_port_immutable(struct ib_device *ibdev, u32 port_num,
 				struct ib_port_immutable *immutable)
 {
 	struct ib_port_attr attr;
@@ -2446,7 +2446,7 @@ static void i40iw_get_dev_fw_str(struct ib_device *dev, char *str)
  * @port_num: port number
  */
 static struct rdma_hw_stats *i40iw_alloc_hw_stats(struct ib_device *ibdev,
-						  u8 port_num)
+						  u32 port_num)
 {
 	struct i40iw_device *iwdev = to_iwdev(ibdev);
 	struct i40iw_sc_dev *dev = &iwdev->sc_dev;
@@ -2477,7 +2477,7 @@ static struct rdma_hw_stats *i40iw_alloc_hw_stats(struct ib_device *ibdev,
  */
 static int i40iw_get_hw_stats(struct ib_device *ibdev,
 			      struct rdma_hw_stats *stats,
-			      u8 port_num, int index)
+			      u32 port_num, int index)
 {
 	struct i40iw_device *iwdev = to_iwdev(ibdev);
 	struct i40iw_sc_dev *dev = &iwdev->sc_dev;
@@ -2504,7 +2504,7 @@ static int i40iw_get_hw_stats(struct ib_device *ibdev,
  * @gid: Global ID
  */
 static int i40iw_query_gid(struct ib_device *ibdev,
-			   u8 port,
+			   u32 port,
 			   int index,
 			   union ib_gid *gid)
 {
diff --git a/drivers/infiniband/hw/mlx4/alias_GUID.c b/drivers/infiniband/hw/mlx4/alias_GUID.c
index cca414ecfcd5..571d9c542024 100644
--- a/drivers/infiniband/hw/mlx4/alias_GUID.c
+++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
@@ -73,12 +73,12 @@ static int get_low_record_time_index(struct mlx4_ib_dev *dev, u8 port,
 				     int *resched_delay_sec);

 void mlx4_ib_update_cache_on_guid_change(struct mlx4_ib_dev *dev, int block_num,
-					 u8 port_num, u8 *p_data)
+					 u32 port_num, u8 *p_data)
 {
 	int i;
 	u64 guid_indexes;
 	int slave_id;
-	int port_index = port_num - 1;
+	u32 port_index = port_num - 1;

 	if (!mlx4_is_master(dev->dev))
 		return;
@@ -86,7 +86,7 @@ void mlx4_ib_update_cache_on_guid_change(struct mlx4_ib_dev *dev, int block_num,
 	guid_indexes = be64_to_cpu((__force __be64) dev->sriov.alias_guid.
 				   ports_guid[port_num - 1].
 				   all_rec_per_port[block_num].guid_indexes);
-	pr_debug("port: %d, guid_indexes: 0x%llx\n", port_num, guid_indexes);
+	pr_debug("port: %u, guid_indexes: 0x%llx\n", port_num, guid_indexes);

 	for (i = 0; i < NUM_ALIAS_GUID_IN_REC; i++) {
 		/* The location of the specific index starts from bit number 4
@@ -184,7 +184,7 @@ void mlx4_ib_slave_alias_guid_event(struct mlx4_ib_dev *dev, int slave,
  * port_number - 1 or 2
  */
 void mlx4_ib_notify_slaves_on_guid_change(struct mlx4_ib_dev *dev,
-					  int block_num, u8 port_num,
+					  int block_num, u32 port_num,
 					  u8 *p_data)
 {
 	int i;
@@ -206,7 +206,7 @@ void mlx4_ib_notify_slaves_on_guid_change(struct mlx4_ib_dev *dev,
 	guid_indexes = be64_to_cpu((__force __be64) dev->sriov.alias_guid.
 				   ports_guid[port_num - 1].
 				   all_rec_per_port[block_num].guid_indexes);
-	pr_debug("port: %d, guid_indexes: 0x%llx\n", port_num, guid_indexes);
+	pr_debug("port: %u, guid_indexes: 0x%llx\n", port_num, guid_indexes);

 	/*calculate the slaves and notify them*/
 	for (i = 0; i < NUM_ALIAS_GUID_IN_REC; i++) {
@@ -260,11 +260,11 @@ void mlx4_ib_notify_slaves_on_guid_change(struct mlx4_ib_dev *dev,
 			new_state = set_and_calc_slave_port_state(dev->dev, slave_id, port_num,
 								  MLX4_PORT_STATE_IB_PORT_STATE_EVENT_GID_VALID,
 								  &gen_event);
-			pr_debug("slave: %d, port: %d prev_port_state: %d,"
+			pr_debug("slave: %d, port: %u prev_port_state: %d,"
 				 " new_port_state: %d, gen_event: %d\n",
 				 slave_id, port_num, prev_state, new_state, gen_event);
 			if (gen_event == SLAVE_PORT_GEN_EVENT_UP) {
-				pr_debug("sending PORT_UP event to slave: %d, port: %d\n",
+				pr_debug("sending PORT_UP event to slave: %d, port: %u\n",
 					 slave_id, port_num);
 				mlx4_gen_port_state_change_eqe(dev->dev, slave_id,
 							       port_num, MLX4_PORT_CHANGE_SUBTYPE_ACTIVE);
@@ -274,7 +274,7 @@ void mlx4_ib_notify_slaves_on_guid_change(struct mlx4_ib_dev *dev,
 						      MLX4_PORT_STATE_IB_EVENT_GID_INVALID,
 						      &gen_event);
 			if (gen_event == SLAVE_PORT_GEN_EVENT_DOWN) {
-				pr_debug("sending PORT DOWN event to slave: %d, port: %d\n",
+				pr_debug("sending PORT DOWN event to slave: %d, port: %u\n",
 					 slave_id, port_num);
 				mlx4_gen_port_state_change_eqe(dev->dev,
 							       slave_id,
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index f3ace85552f3..d13ecbdd4391 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -88,8 +88,8 @@ struct mlx4_rcv_tunnel_mad {
 	struct ib_mad mad;
 } __packed;

-static void handle_client_rereg_event(struct mlx4_ib_dev *dev, u8 port_num);
-static void handle_lid_change_event(struct mlx4_ib_dev *dev, u8 port_num);
+static void handle_client_rereg_event(struct mlx4_ib_dev *dev, u32 port_num);
+static void handle_lid_change_event(struct mlx4_ib_dev *dev, u32 port_num);
 static void __propagate_pkey_ev(struct mlx4_ib_dev *dev, int port_num,
 				int block, u32 change_bitmap);

@@ -186,7 +186,7 @@ int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int mad_ifc_flags,
 	return err;
 }

-static void update_sm_ah(struct mlx4_ib_dev *dev, u8 port_num, u16 lid, u8 sl)
+static void update_sm_ah(struct mlx4_ib_dev *dev, u32 port_num, u16 lid, u8 sl)
 {
 	struct ib_ah *new_ah;
 	struct rdma_ah_attr ah_attr;
@@ -217,8 +217,8 @@ static void update_sm_ah(struct mlx4_ib_dev *dev, u8 port_num, u16 lid, u8 sl)
  * Snoop SM MADs for port info, GUID info, and  P_Key table sets, so we can
  * synthesize LID change, Client-Rereg, GID change, and P_Key change events.
  */
-static void smp_snoop(struct ib_device *ibdev, u8 port_num, const struct ib_mad *mad,
-		      u16 prev_lid)
+static void smp_snoop(struct ib_device *ibdev, u32 port_num,
+		      const struct ib_mad *mad, u16 prev_lid)
 {
 	struct ib_port_info *pinfo;
 	u16 lid;
@@ -274,7 +274,7 @@ static void smp_snoop(struct ib_device *ibdev, u8 port_num, const struct ib_mad
 						be16_to_cpu(base[i]);
 				}
 			}
-			pr_debug("PKEY Change event: port=%d, "
+			pr_debug("PKEY Change event: port=%u, "
 				 "block=0x%x, change_bitmap=0x%x\n",
 				 port_num, bn, pkey_change_bitmap);

@@ -380,7 +380,8 @@ static void node_desc_override(struct ib_device *dev,
 	}
 }

-static void forward_trap(struct mlx4_ib_dev *dev, u8 port_num, const struct ib_mad *mad)
+static void forward_trap(struct mlx4_ib_dev *dev, u32 port_num,
+			 const struct ib_mad *mad)
 {
 	int qpn = mad->mad_hdr.mgmt_class != IB_MGMT_CLASS_SUBN_LID_ROUTED;
 	struct ib_mad_send_buf *send_buf;
@@ -429,7 +430,7 @@ static int mlx4_ib_demux_sa_handler(struct ib_device *ibdev, int port, int slave
 	return ret;
 }

-int mlx4_ib_find_real_gid(struct ib_device *ibdev, u8 port, __be64 guid)
+int mlx4_ib_find_real_gid(struct ib_device *ibdev, u32 port, __be64 guid)
 {
 	struct mlx4_ib_dev *dev = to_mdev(ibdev);
 	int i;
@@ -443,7 +444,7 @@ int mlx4_ib_find_real_gid(struct ib_device *ibdev, u8 port, __be64 guid)


 static int find_slave_port_pkey_ix(struct mlx4_ib_dev *dev, int slave,
-				   u8 port, u16 pkey, u16 *ix)
+				   u32 port, u16 pkey, u16 *ix)
 {
 	int i, ret;
 	u8 unassigned_pkey_ix, pkey_ix, partial_ix = 0xFF;
@@ -507,7 +508,7 @@ static int is_proxy_qp0(struct mlx4_ib_dev *dev, int qpn, int slave)
 	return (qpn >= proxy_start && qpn <= proxy_start + 1);
 }

-int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
+int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u32 port,
 			  enum ib_qp_type dest_qpt, struct ib_wc *wc,
 			  struct ib_grh *grh, struct ib_mad *mad)
 {
@@ -678,7 +679,7 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 	return ret;
 }

-static int mlx4_ib_demux_mad(struct ib_device *ibdev, u8 port,
+static int mlx4_ib_demux_mad(struct ib_device *ibdev, u32 port,
 			struct ib_wc *wc, struct ib_grh *grh,
 			struct ib_mad *mad)
 {
@@ -818,7 +819,7 @@ static int mlx4_ib_demux_mad(struct ib_device *ibdev, u8 port,
 	return 0;
 }

-static int ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
+static int ib_process_mad(struct ib_device *ibdev, int mad_flags, u32 port_num,
 			const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 			const struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
@@ -932,9 +933,10 @@ static int iboe_process_mad_port_info(void *out_mad)
 	return IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY;
 }

-static int iboe_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
-			const struct ib_wc *in_wc, const struct ib_grh *in_grh,
-			const struct ib_mad *in_mad, struct ib_mad *out_mad)
+static int iboe_process_mad(struct ib_device *ibdev, int mad_flags,
+			    u32 port_num, const struct ib_wc *in_wc,
+			    const struct ib_grh *in_grh,
+			    const struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
 	struct mlx4_counter counter_stats;
 	struct mlx4_ib_dev *dev = to_mdev(ibdev);
@@ -979,7 +981,7 @@ static int iboe_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 	return err;
 }

-int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
+int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags, u32 port_num,
 			const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 			const struct ib_mad *in, struct ib_mad *out,
 			size_t *out_mad_size, u16 *out_mad_pkey_index)
@@ -1073,7 +1075,7 @@ void mlx4_ib_mad_cleanup(struct mlx4_ib_dev *dev)
 	}
 }

-static void handle_lid_change_event(struct mlx4_ib_dev *dev, u8 port_num)
+static void handle_lid_change_event(struct mlx4_ib_dev *dev, u32 port_num)
 {
 	mlx4_ib_dispatch_event(dev, port_num, IB_EVENT_LID_CHANGE);

@@ -1082,7 +1084,7 @@ static void handle_lid_change_event(struct mlx4_ib_dev *dev, u8 port_num)
 					    MLX4_EQ_PORT_INFO_LID_CHANGE_MASK);
 }

-static void handle_client_rereg_event(struct mlx4_ib_dev *dev, u8 port_num)
+static void handle_client_rereg_event(struct mlx4_ib_dev *dev, u32 port_num)
 {
 	/* re-configure the alias-guid and mcg's */
 	if (mlx4_is_master(dev->dev)) {
@@ -1121,7 +1123,7 @@ static void propagate_pkey_ev(struct mlx4_ib_dev *dev, int port_num,
 			    GET_MASK_FROM_EQE(eqe));
 }

-static void handle_slaves_guid_change(struct mlx4_ib_dev *dev, u8 port_num,
+static void handle_slaves_guid_change(struct mlx4_ib_dev *dev, u32 port_num,
 				      u32 guid_tbl_blk_num, u32 change_bitmap)
 {
 	struct ib_smp *in_mad  = NULL;
@@ -1177,7 +1179,7 @@ void handle_port_mgmt_change_event(struct work_struct *work)
 	struct ib_event_work *ew = container_of(work, struct ib_event_work, work);
 	struct mlx4_ib_dev *dev = ew->ib_dev;
 	struct mlx4_eqe *eqe = &(ew->ib_eqe);
-	u8 port = eqe->event.port_mgmt_change.port;
+	u32 port = eqe->event.port_mgmt_change.port;
 	u32 changed_attr;
 	u32 tbl_block;
 	u32 change_bitmap;
@@ -1274,7 +1276,7 @@ void handle_port_mgmt_change_event(struct work_struct *work)
 	kfree(ew);
 }

-void mlx4_ib_dispatch_event(struct mlx4_ib_dev *dev, u8 port_num,
+void mlx4_ib_dispatch_event(struct mlx4_ib_dev *dev, u32 port_num,
 			    enum ib_event_type type)
 {
 	struct ib_event event;
@@ -1351,7 +1353,7 @@ static int mlx4_ib_multiplex_sa_handler(struct ib_device *ibdev, int port,
 	return ret;
 }

-int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u8 port,
+int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u32 port,
 			 enum ib_qp_type dest_qpt, u16 pkey_index,
 			 u32 remote_qpn, u32 qkey, struct rdma_ah_attr *attr,
 			 u8 *s_mac, u16 vlan_id, struct ib_mad *mad)
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index f26a0d920842..22898d97ecbd 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -81,7 +81,7 @@ static const char mlx4_ib_version[] =

 static void do_slave_init(struct mlx4_ib_dev *ibdev, int slave, int do_init);
 static enum rdma_link_layer mlx4_ib_port_link_layer(struct ib_device *device,
-						    u8 port_num);
+						    u32 port_num);

 static struct workqueue_struct *wq;

@@ -129,7 +129,8 @@ static int num_ib_ports(struct mlx4_dev *dev)
 	return ib_ports;
 }

-static struct net_device *mlx4_ib_get_netdev(struct ib_device *device, u8 port_num)
+static struct net_device *mlx4_ib_get_netdev(struct ib_device *device,
+					     u32 port_num)
 {
 	struct mlx4_ib_dev *ibdev = to_mdev(device);
 	struct net_device *dev;
@@ -160,7 +161,7 @@ static struct net_device *mlx4_ib_get_netdev(struct ib_device *device, u8 port_n

 static int mlx4_ib_update_gids_v1(struct gid_entry *gids,
 				  struct mlx4_ib_dev *ibdev,
-				  u8 port_num)
+				  u32 port_num)
 {
 	struct mlx4_cmd_mailbox *mailbox;
 	int err;
@@ -193,7 +194,7 @@ static int mlx4_ib_update_gids_v1(struct gid_entry *gids,

 static int mlx4_ib_update_gids_v1_v2(struct gid_entry *gids,
 				     struct mlx4_ib_dev *ibdev,
-				     u8 port_num)
+				     u32 port_num)
 {
 	struct mlx4_cmd_mailbox *mailbox;
 	int err;
@@ -238,7 +239,7 @@ static int mlx4_ib_update_gids_v1_v2(struct gid_entry *gids,

 static int mlx4_ib_update_gids(struct gid_entry *gids,
 			       struct mlx4_ib_dev *ibdev,
-			       u8 port_num)
+			       u32 port_num)
 {
 	if (ibdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2)
 		return mlx4_ib_update_gids_v1_v2(gids, ibdev, port_num);
@@ -407,7 +408,7 @@ int mlx4_ib_gid_index_to_real_index(struct mlx4_ib_dev *ibdev,
 	int real_index = -EINVAL;
 	int i;
 	unsigned long flags;
-	u8 port_num = attr->port_num;
+	u32 port_num = attr->port_num;

 	if (port_num > MLX4_MAX_PORTS)
 		return -EINVAL;
@@ -649,7 +650,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 }

 static enum rdma_link_layer
-mlx4_ib_port_link_layer(struct ib_device *device, u8 port_num)
+mlx4_ib_port_link_layer(struct ib_device *device, u32 port_num)
 {
 	struct mlx4_dev *dev = to_mdev(device)->dev;

@@ -657,7 +658,7 @@ mlx4_ib_port_link_layer(struct ib_device *device, u8 port_num)
 		IB_LINK_LAYER_INFINIBAND : IB_LINK_LAYER_ETHERNET;
 }

-static int ib_link_query_port(struct ib_device *ibdev, u8 port,
+static int ib_link_query_port(struct ib_device *ibdev, u32 port,
 			      struct ib_port_attr *props, int netw_view)
 {
 	struct ib_smp *in_mad  = NULL;
@@ -753,7 +754,7 @@ static u8 state_to_phys_state(enum ib_port_state state)
 		IB_PORT_PHYS_STATE_LINK_UP : IB_PORT_PHYS_STATE_DISABLED;
 }

-static int eth_link_query_port(struct ib_device *ibdev, u8 port,
+static int eth_link_query_port(struct ib_device *ibdev, u32 port,
 			       struct ib_port_attr *props)
 {

@@ -814,7 +815,7 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 	return err;
 }

-int __mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
+int __mlx4_ib_query_port(struct ib_device *ibdev, u32 port,
 			 struct ib_port_attr *props, int netw_view)
 {
 	int err;
@@ -828,14 +829,14 @@ int __mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
 	return err;
 }

-static int mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
+static int mlx4_ib_query_port(struct ib_device *ibdev, u32 port,
 			      struct ib_port_attr *props)
 {
 	/* returns host view */
 	return __mlx4_ib_query_port(ibdev, port, props, 0);
 }

-int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
+int __mlx4_ib_query_gid(struct ib_device *ibdev, u32 port, int index,
 			union ib_gid *gid, int netw_view)
 {
 	struct ib_smp *in_mad  = NULL;
@@ -891,7 +892,7 @@ int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 	return err;
 }

-static int mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
+static int mlx4_ib_query_gid(struct ib_device *ibdev, u32 port, int index,
 			     union ib_gid *gid)
 {
 	if (rdma_protocol_ib(ibdev, port))
@@ -899,7 +900,8 @@ static int mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 	return 0;
 }

-static int mlx4_ib_query_sl2vl(struct ib_device *ibdev, u8 port, u64 *sl2vl_tbl)
+static int mlx4_ib_query_sl2vl(struct ib_device *ibdev, u32 port,
+			       u64 *sl2vl_tbl)
 {
 	union sl2vl_tbl_to_u64 sl2vl64;
 	struct ib_smp *in_mad  = NULL;
@@ -959,7 +961,7 @@ static void mlx4_init_sl2vl_tbl(struct mlx4_ib_dev *mdev)
 	}
 }

-int __mlx4_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
+int __mlx4_ib_query_pkey(struct ib_device *ibdev, u32 port, u16 index,
 			 u16 *pkey, int netw_view)
 {
 	struct ib_smp *in_mad  = NULL;
@@ -992,7 +994,8 @@ int __mlx4_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
 	return err;
 }

-static int mlx4_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index, u16 *pkey)
+static int mlx4_ib_query_pkey(struct ib_device *ibdev, u32 port, u16 index,
+			      u16 *pkey)
 {
 	return __mlx4_ib_query_pkey(ibdev, port, index, pkey, 0);
 }
@@ -1033,8 +1036,8 @@ static int mlx4_ib_modify_device(struct ib_device *ibdev, int mask,
 	return 0;
 }

-static int mlx4_ib_SET_PORT(struct mlx4_ib_dev *dev, u8 port, int reset_qkey_viols,
-			    u32 cap_mask)
+static int mlx4_ib_SET_PORT(struct mlx4_ib_dev *dev, u32 port,
+			    int reset_qkey_viols, u32 cap_mask)
 {
 	struct mlx4_cmd_mailbox *mailbox;
 	int err;
@@ -1059,7 +1062,7 @@ static int mlx4_ib_SET_PORT(struct mlx4_ib_dev *dev, u8 port, int reset_qkey_vio
 	return err;
 }

-static int mlx4_ib_modify_port(struct ib_device *ibdev, u8 port, int mask,
+static int mlx4_ib_modify_port(struct ib_device *ibdev, u32 port, int mask,
 			       struct ib_port_modify *props)
 {
 	struct mlx4_ib_dev *mdev = to_mdev(ibdev);
@@ -2103,7 +2106,7 @@ static const struct diag_counter diag_device_only[] = {
 };

 static struct rdma_hw_stats *mlx4_ib_alloc_hw_stats(struct ib_device *ibdev,
-						    u8 port_num)
+						    u32 port_num)
 {
 	struct mlx4_ib_dev *dev = to_mdev(ibdev);
 	struct mlx4_ib_diag_counters *diag = dev->diag_counters;
@@ -2118,7 +2121,7 @@ static struct rdma_hw_stats *mlx4_ib_alloc_hw_stats(struct ib_device *ibdev,

 static int mlx4_ib_get_hw_stats(struct ib_device *ibdev,
 				struct rdma_hw_stats *stats,
-				u8 port, int index)
+				u32 port, int index)
 {
 	struct mlx4_ib_dev *dev = to_mdev(ibdev);
 	struct mlx4_ib_diag_counters *diag = dev->diag_counters;
@@ -2466,7 +2469,7 @@ static void mlx4_ib_free_eqs(struct mlx4_dev *dev, struct mlx4_ib_dev *ibdev)
 	ibdev->eq_table = NULL;
 }

-static int mlx4_port_immutable(struct ib_device *ibdev, u8 port_num,
+static int mlx4_port_immutable(struct ib_device *ibdev, u32 port_num,
 			       struct ib_port_immutable *immutable)
 {
 	struct ib_port_attr attr;
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 78c9bb79ec75..e856cf23a0a1 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -429,7 +429,7 @@ struct mlx4_sriov_alias_guid_port_rec_det {
 	struct mlx4_sriov_alias_guid_info_rec_det all_rec_per_port[NUM_ALIAS_GUID_REC_IN_PORT];
 	struct workqueue_struct *wq;
 	struct delayed_work alias_guid_work;
-	u8 port;
+	u32 port;
 	u32 state_flags;
 	struct mlx4_sriov_alias_guid *parent;
 	struct list_head cb_list;
@@ -657,7 +657,7 @@ struct mlx4_ib_qp_tunnel_init_attr {
 	struct ib_qp_init_attr init_attr;
 	int slave;
 	enum ib_qp_type proxy_qp_type;
-	u8 port;
+	u32 port;
 };

 struct mlx4_uverbs_ex_query_device {
@@ -810,24 +810,24 @@ int mlx4_ib_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
 int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int mad_ifc_flags,
 		 int port, const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 		 const void *in_mad, void *response_mad);
-int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
+int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags, u32 port_num,
 			const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 			const struct ib_mad *in, struct ib_mad *out,
 			size_t *out_mad_size, u16 *out_mad_pkey_index);
 int mlx4_ib_mad_init(struct mlx4_ib_dev *dev);
 void mlx4_ib_mad_cleanup(struct mlx4_ib_dev *dev);

-int __mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
+int __mlx4_ib_query_port(struct ib_device *ibdev, u32 port,
 			 struct ib_port_attr *props, int netw_view);
-int __mlx4_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
+int __mlx4_ib_query_pkey(struct ib_device *ibdev, u32 port, u16 index,
 			 u16 *pkey, int netw_view);

-int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
+int __mlx4_ib_query_gid(struct ib_device *ibdev, u32 port, int index,
 			union ib_gid *gid, int netw_view);

 static inline bool mlx4_ib_ah_grh_present(struct mlx4_ib_ah *ah)
 {
-	u8 port = be32_to_cpu(ah->av.ib.port_pd) >> 24 & 3;
+	u32 port = be32_to_cpu(ah->av.ib.port_pd) >> 24 & 3;

 	if (rdma_port_get_link_layer(ah->ibah.device, port) == IB_LINK_LAYER_ETHERNET)
 		return true;
@@ -841,7 +841,7 @@ void clean_vf_mcast(struct mlx4_ib_demux_ctx *ctx, int slave);
 int mlx4_ib_mcg_init(void);
 void mlx4_ib_mcg_destroy(void);

-int mlx4_ib_find_real_gid(struct ib_device *ibdev, u8 port, __be64 guid);
+int mlx4_ib_find_real_gid(struct ib_device *ibdev, u32 port, __be64 guid);

 int mlx4_ib_mcg_multiplex_handler(struct ib_device *ibdev, int port, int slave,
 				  struct ib_sa_mad *sa_mad);
@@ -851,16 +851,16 @@ int mlx4_ib_mcg_demux_handler(struct ib_device *ibdev, int port, int slave,
 int mlx4_ib_add_mc(struct mlx4_ib_dev *mdev, struct mlx4_ib_qp *mqp,
 		   union ib_gid *gid);

-void mlx4_ib_dispatch_event(struct mlx4_ib_dev *dev, u8 port_num,
+void mlx4_ib_dispatch_event(struct mlx4_ib_dev *dev, u32 port_num,
 			    enum ib_event_type type);

 void mlx4_ib_tunnels_update_work(struct work_struct *work);

-int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
+int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u32 port,
 			  enum ib_qp_type qpt, struct ib_wc *wc,
 			  struct ib_grh *grh, struct ib_mad *mad);

-int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u8 port,
+int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u32 port,
 			 enum ib_qp_type dest_qpt, u16 pkey_index, u32 remote_qpn,
 			 u32 qkey, struct rdma_ah_attr *attr, u8 *s_mac,
 			 u16 vlan_id, struct ib_mad *mad);
@@ -884,10 +884,10 @@ void mlx4_ib_invalidate_all_guid_record(struct mlx4_ib_dev *dev, int port);

 void mlx4_ib_notify_slaves_on_guid_change(struct mlx4_ib_dev *dev,
 					  int block_num,
-					  u8 port_num, u8 *p_data);
+					  u32 port_num, u8 *p_data);

 void mlx4_ib_update_cache_on_guid_change(struct mlx4_ib_dev *dev,
-					 int block_num, u8 port_num,
+					 int block_num, u32 port_num,
 					 u8 *p_data);

 int add_sysfs_port_mcg_attr(struct mlx4_ib_dev *device, int port_num,
diff --git a/drivers/infiniband/hw/mlx5/cong.c b/drivers/infiniband/hw/mlx5/cong.c
index b9291e482428..0b61df52332a 100644
--- a/drivers/infiniband/hw/mlx5/cong.c
+++ b/drivers/infiniband/hw/mlx5/cong.c
@@ -267,7 +267,7 @@ static void mlx5_ib_set_cc_param_mask_val(void *field, int offset,
 	}
 }

-static int mlx5_ib_get_cc_params(struct mlx5_ib_dev *dev, u8 port_num,
+static int mlx5_ib_get_cc_params(struct mlx5_ib_dev *dev, u32 port_num,
 				 int offset, u32 *var)
 {
 	int outlen = MLX5_ST_SZ_BYTES(query_cong_params_out);
@@ -304,7 +304,7 @@ static int mlx5_ib_get_cc_params(struct mlx5_ib_dev *dev, u8 port_num,
 	return err;
 }

-static int mlx5_ib_set_cc_params(struct mlx5_ib_dev *dev, u8 port_num,
+static int mlx5_ib_set_cc_params(struct mlx5_ib_dev *dev, u32 port_num,
 				 int offset, u32 var)
 {
 	int inlen = MLX5_ST_SZ_BYTES(modify_cong_params_in);
@@ -397,7 +397,7 @@ static const struct file_operations dbg_cc_fops = {
 	.read	= get_param,
 };

-void mlx5_ib_cleanup_cong_debugfs(struct mlx5_ib_dev *dev, u8 port_num)
+void mlx5_ib_cleanup_cong_debugfs(struct mlx5_ib_dev *dev, u32 port_num)
 {
 	if (!mlx5_debugfs_root ||
 	    !dev->port[port_num].dbg_cc_params ||
@@ -409,7 +409,7 @@ void mlx5_ib_cleanup_cong_debugfs(struct mlx5_ib_dev *dev, u8 port_num)
 	dev->port[port_num].dbg_cc_params = NULL;
 }

-void mlx5_ib_init_cong_debugfs(struct mlx5_ib_dev *dev, u8 port_num)
+void mlx5_ib_init_cong_debugfs(struct mlx5_ib_dev *dev, u32 port_num)
 {
 	struct mlx5_ib_dbg_cc_params *dbg_cc_params;
 	struct mlx5_core_dev *mdev;
diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index 084652e2b15a..e365341057cb 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -139,7 +139,7 @@ static int mlx5_ib_create_counters(struct ib_counters *counters,


 static const struct mlx5_ib_counters *get_counters(struct mlx5_ib_dev *dev,
-						   u8 port_num)
+						   u32 port_num)
 {
 	return is_mdev_switchdev_mode(dev->mdev) ? &dev->port[0].cnts :
 						   &dev->port[port_num].cnts;
@@ -154,7 +154,7 @@ static const struct mlx5_ib_counters *get_counters(struct mlx5_ib_dev *dev,
  * device port combination in switchdev and non switchdev mode of the
  * parent device.
  */
-u16 mlx5_ib_get_counters_id(struct mlx5_ib_dev *dev, u8 port_num)
+u16 mlx5_ib_get_counters_id(struct mlx5_ib_dev *dev, u32 port_num)
 {
 	const struct mlx5_ib_counters *cnts = get_counters(dev, port_num);

@@ -162,7 +162,7 @@ u16 mlx5_ib_get_counters_id(struct mlx5_ib_dev *dev, u8 port_num)
 }

 static struct rdma_hw_stats *mlx5_ib_alloc_hw_stats(struct ib_device *ibdev,
-						    u8 port_num)
+						    u32 port_num)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	const struct mlx5_ib_counters *cnts;
@@ -236,13 +236,13 @@ static int mlx5_ib_query_ext_ppcnt_counters(struct mlx5_ib_dev *dev,

 static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 				struct rdma_hw_stats *stats,
-				u8 port_num, int index)
+				u32 port_num, int index)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	const struct mlx5_ib_counters *cnts = get_counters(dev, port_num - 1);
 	struct mlx5_core_dev *mdev;
 	int ret, num_counters;
-	u8 mdev_port_num;
+	u32 mdev_port_num;

 	if (!stats)
 		return -EINVAL;
diff --git a/drivers/infiniband/hw/mlx5/counters.h b/drivers/infiniband/hw/mlx5/counters.h
index 1aa30c2f3f4d..6bcaaa52e2b2 100644
--- a/drivers/infiniband/hw/mlx5/counters.h
+++ b/drivers/infiniband/hw/mlx5/counters.h
@@ -13,5 +13,5 @@ void mlx5_ib_counters_cleanup(struct mlx5_ib_dev *dev);
 void mlx5_ib_counters_clear_description(struct ib_counters *counters);
 int mlx5_ib_flow_counters_set_data(struct ib_counters *ibcounters,
 				   struct mlx5_ib_create_flow *ucmd);
-u16 mlx5_ib_get_counters_id(struct mlx5_ib_dev *dev, u8 port_num);
+u16 mlx5_ib_get_counters_id(struct mlx5_ib_dev *dev, u32 port_num);
 #endif /* _MLX5_IB_COUNTERS_H */
diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 9164cc069ad4..83463ebac475 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -29,7 +29,7 @@ mlx5_ib_set_vport_rep(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 static int
 mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 {
-	int num_ports = mlx5_eswitch_get_total_vports(dev);
+	u32 num_ports = mlx5_eswitch_get_total_vports(dev);
 	const struct mlx5_ib_profile *profile;
 	struct mlx5_ib_dev *ibdev;
 	int vport_index;
@@ -110,7 +110,7 @@ struct net_device *mlx5_ib_get_rep_netdev(struct mlx5_eswitch *esw,

 struct mlx5_flow_handle *create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
 						   struct mlx5_ib_sq *sq,
-						   u16 port)
+						   u32 port)
 {
 	struct mlx5_eswitch *esw = dev->mdev->priv.eswitch;
 	struct mlx5_eswitch_rep *rep;
diff --git a/drivers/infiniband/hw/mlx5/ib_rep.h b/drivers/infiniband/hw/mlx5/ib_rep.h
index ce1dcb105dbd..9c55e5c528b4 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.h
+++ b/drivers/infiniband/hw/mlx5/ib_rep.h
@@ -16,7 +16,7 @@ int mlx5r_rep_init(void);
 void mlx5r_rep_cleanup(void);
 struct mlx5_flow_handle *create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
 						   struct mlx5_ib_sq *sq,
-						   u16 port);
+						   u32 port);
 struct net_device *mlx5_ib_get_rep_netdev(struct mlx5_eswitch *esw,
 					  u16 vport_num);
 #else /* CONFIG_MLX5_ESWITCH */
@@ -25,7 +25,7 @@ static inline void mlx5r_rep_cleanup(void) {}
 static inline
 struct mlx5_flow_handle *create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
 						   struct mlx5_ib_sq *sq,
-						   u16 port)
+						   u32 port)
 {
 	return NULL;
 }
diff --git a/drivers/infiniband/hw/mlx5/ib_virt.c b/drivers/infiniband/hw/mlx5/ib_virt.c
index 46b2d370fb3f..f2f62875d072 100644
--- a/drivers/infiniband/hw/mlx5/ib_virt.c
+++ b/drivers/infiniband/hw/mlx5/ib_virt.c
@@ -48,7 +48,7 @@ static inline u32 mlx_to_net_policy(enum port_state_policy mlx_policy)
 	}
 }

-int mlx5_ib_get_vf_config(struct ib_device *device, int vf, u8 port,
+int mlx5_ib_get_vf_config(struct ib_device *device, int vf, u32 port,
 			  struct ifla_vf_info *info)
 {
 	struct mlx5_ib_dev *dev = to_mdev(device);
@@ -91,7 +91,7 @@ static inline enum port_state_policy net_to_mlx_policy(int policy)
 }

 int mlx5_ib_set_vf_link_state(struct ib_device *device, int vf,
-			      u8 port, int state)
+			      u32 port, int state)
 {
 	struct mlx5_ib_dev *dev = to_mdev(device);
 	struct mlx5_core_dev *mdev = dev->mdev;
@@ -119,7 +119,7 @@ int mlx5_ib_set_vf_link_state(struct ib_device *device, int vf,
 }

 int mlx5_ib_get_vf_stats(struct ib_device *device, int vf,
-			 u8 port, struct ifla_vf_stats *stats)
+			 u32 port, struct ifla_vf_stats *stats)
 {
 	int out_sz = MLX5_ST_SZ_BYTES(query_vport_counter_out);
 	struct mlx5_core_dev *mdev;
@@ -149,7 +149,8 @@ int mlx5_ib_get_vf_stats(struct ib_device *device, int vf,
 	return err;
 }

-static int set_vf_node_guid(struct ib_device *device, int vf, u8 port, u64 guid)
+static int set_vf_node_guid(struct ib_device *device, int vf, u32 port,
+			    u64 guid)
 {
 	struct mlx5_ib_dev *dev = to_mdev(device);
 	struct mlx5_core_dev *mdev = dev->mdev;
@@ -172,7 +173,8 @@ static int set_vf_node_guid(struct ib_device *device, int vf, u8 port, u64 guid)
 	return err;
 }

-static int set_vf_port_guid(struct ib_device *device, int vf, u8 port, u64 guid)
+static int set_vf_port_guid(struct ib_device *device, int vf, u32 port,
+			    u64 guid)
 {
 	struct mlx5_ib_dev *dev = to_mdev(device);
 	struct mlx5_core_dev *mdev = dev->mdev;
@@ -195,7 +197,7 @@ static int set_vf_port_guid(struct ib_device *device, int vf, u8 port, u64 guid)
 	return err;
 }

-int mlx5_ib_set_vf_guid(struct ib_device *device, int vf, u8 port,
+int mlx5_ib_set_vf_guid(struct ib_device *device, int vf, u32 port,
 			u64 guid, int type)
 {
 	if (type == IFLA_VF_IB_NODE_GUID)
@@ -206,7 +208,7 @@ int mlx5_ib_set_vf_guid(struct ib_device *device, int vf, u8 port,
 	return -EINVAL;
 }

-int mlx5_ib_get_vf_guid(struct ib_device *device, int vf, u8 port,
+int mlx5_ib_get_vf_guid(struct ib_device *device, int vf, u32 port,
 			struct ifla_vf_guid *node_guid,
 			struct ifla_vf_guid *port_guid)
 {
diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 652c6ccf1881..ec242a5a17a3 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -42,7 +42,7 @@ enum {
 	MLX5_IB_VENDOR_CLASS2 = 0xa
 };

-static bool can_do_mad_ifc(struct mlx5_ib_dev *dev, u8 port_num,
+static bool can_do_mad_ifc(struct mlx5_ib_dev *dev, u32 port_num,
 			   struct ib_mad *in_mad)
 {
 	if (in_mad->mad_hdr.mgmt_class != IB_MGMT_CLASS_SUBN_LID_ROUTED &&
@@ -52,7 +52,7 @@ static bool can_do_mad_ifc(struct mlx5_ib_dev *dev, u8 port_num,
 }

 static int mlx5_MAD_IFC(struct mlx5_ib_dev *dev, int ignore_mkey,
-			int ignore_bkey, u8 port, const struct ib_wc *in_wc,
+			int ignore_bkey, u32 port, const struct ib_wc *in_wc,
 			const struct ib_grh *in_grh, const void *in_mad,
 			void *response_mad)
 {
@@ -147,12 +147,12 @@ static void pma_cnt_assign(struct ib_pma_portcounters *pma_cnt,
 			     vl_15_dropped);
 }

-static int process_pma_cmd(struct mlx5_ib_dev *dev, u8 port_num,
+static int process_pma_cmd(struct mlx5_ib_dev *dev, u32 port_num,
 			   const struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
 	struct mlx5_core_dev *mdev;
 	bool native_port = true;
-	u8 mdev_port_num;
+	u32 mdev_port_num;
 	void *out_cnt;
 	int err;

@@ -216,7 +216,7 @@ static int process_pma_cmd(struct mlx5_ib_dev *dev, u8 port_num,
 	return err;
 }

-int mlx5_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
+int mlx5_ib_process_mad(struct ib_device *ibdev, int mad_flags, u32 port_num,
 			const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 			const struct ib_mad *in, struct ib_mad *out,
 			size_t *out_mad_size, u16 *out_mad_pkey_index)
@@ -444,7 +444,7 @@ int mlx5_query_mad_ifc_node_guid(struct mlx5_ib_dev *dev, __be64 *node_guid)
 	return err;
 }

-int mlx5_query_mad_ifc_pkey(struct ib_device *ibdev, u8 port, u16 index,
+int mlx5_query_mad_ifc_pkey(struct ib_device *ibdev, u32 port, u16 index,
 			    u16 *pkey)
 {
 	struct ib_smp *in_mad  = NULL;
@@ -473,7 +473,7 @@ int mlx5_query_mad_ifc_pkey(struct ib_device *ibdev, u8 port, u16 index,
 	return err;
 }

-int mlx5_query_mad_ifc_gids(struct ib_device *ibdev, u8 port, int index,
+int mlx5_query_mad_ifc_gids(struct ib_device *ibdev, u32 port, int index,
 			    union ib_gid *gid)
 {
 	struct ib_smp *in_mad  = NULL;
@@ -513,7 +513,7 @@ int mlx5_query_mad_ifc_gids(struct ib_device *ibdev, u8 port, int index,
 	return err;
 }

-int mlx5_query_mad_ifc_port(struct ib_device *ibdev, u8 port,
+int mlx5_query_mad_ifc_port(struct ib_device *ibdev, u32 port,
 			    struct ib_port_attr *props)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 0d69a697d75f..b42b5d39a88e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -100,7 +100,7 @@ mlx5_port_type_cap_to_rdma_ll(int port_type_cap)
 }

 static enum rdma_link_layer
-mlx5_ib_port_link_layer(struct ib_device *device, u8 port_num)
+mlx5_ib_port_link_layer(struct ib_device *device, u32 port_num)
 {
 	struct mlx5_ib_dev *dev = to_mdev(device);
 	int port_type_cap = MLX5_CAP_GEN(dev->mdev, port_type);
@@ -109,7 +109,7 @@ mlx5_ib_port_link_layer(struct ib_device *device, u8 port_num)
 }

 static int get_port_state(struct ib_device *ibdev,
-			  u8 port_num,
+			  u32 port_num,
 			  enum ib_port_state *state)
 {
 	struct ib_port_attr attr;
@@ -124,7 +124,7 @@ static int get_port_state(struct ib_device *ibdev,

 static struct mlx5_roce *mlx5_get_rep_roce(struct mlx5_ib_dev *dev,
 					   struct net_device *ndev,
-					   u8 *port_num)
+					   u32 *port_num)
 {
 	struct mlx5_eswitch *esw = dev->mdev->priv.eswitch;
 	struct net_device *rep_ndev;
@@ -155,7 +155,7 @@ static int mlx5_netdev_event(struct notifier_block *this,
 {
 	struct mlx5_roce *roce = container_of(this, struct mlx5_roce, nb);
 	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
-	u8 port_num = roce->native_port_num;
+	u32 port_num = roce->native_port_num;
 	struct mlx5_core_dev *mdev;
 	struct mlx5_ib_dev *ibdev;

@@ -234,7 +234,7 @@ static int mlx5_netdev_event(struct notifier_block *this,
 }

 static struct net_device *mlx5_ib_get_netdev(struct ib_device *device,
-					     u8 port_num)
+					     u32 port_num)
 {
 	struct mlx5_ib_dev *ibdev = to_mdev(device);
 	struct net_device *ndev;
@@ -262,8 +262,8 @@ static struct net_device *mlx5_ib_get_netdev(struct ib_device *device,
 }

 struct mlx5_core_dev *mlx5_ib_get_native_port_mdev(struct mlx5_ib_dev *ibdev,
-						   u8 ib_port_num,
-						   u8 *native_port_num)
+						   u32 ib_port_num,
+						   u32 *native_port_num)
 {
 	enum rdma_link_layer ll = mlx5_ib_port_link_layer(&ibdev->ib_dev,
 							  ib_port_num);
@@ -297,7 +297,7 @@ struct mlx5_core_dev *mlx5_ib_get_native_port_mdev(struct mlx5_ib_dev *ibdev,
 	return mdev;
 }

-void mlx5_ib_put_native_port_mdev(struct mlx5_ib_dev *ibdev, u8 port_num)
+void mlx5_ib_put_native_port_mdev(struct mlx5_ib_dev *ibdev, u32 port_num)
 {
 	enum rdma_link_layer ll = mlx5_ib_port_link_layer(&ibdev->ib_dev,
 							  port_num);
@@ -453,7 +453,7 @@ static int translate_eth_proto_oper(u32 eth_proto_oper, u16 *active_speed,
 						active_width);
 }

-static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
+static int mlx5_query_port_roce(struct ib_device *device, u32 port_num,
 				struct ib_port_attr *props)
 {
 	struct mlx5_ib_dev *dev = to_mdev(device);
@@ -463,7 +463,7 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 	enum ib_mtu ndev_ib_mtu;
 	bool put_mdev = true;
 	u32 eth_prot_oper;
-	u8 mdev_port_num;
+	u32 mdev_port_num;
 	bool ext;
 	int err;

@@ -550,7 +550,7 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 	return err;
 }

-static int set_roce_addr(struct mlx5_ib_dev *dev, u8 port_num,
+static int set_roce_addr(struct mlx5_ib_dev *dev, u32 port_num,
 			 unsigned int index, const union ib_gid *gid,
 			 const struct ib_gid_attr *attr)
 {
@@ -1268,7 +1268,7 @@ static int translate_max_vl_num(struct ib_device *ibdev, u8 vl_hw_cap,
 	return 0;
 }

-static int mlx5_query_hca_port(struct ib_device *ibdev, u8 port,
+static int mlx5_query_hca_port(struct ib_device *ibdev, u32 port,
 			       struct ib_port_attr *props)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
@@ -1336,7 +1336,7 @@ static int mlx5_query_hca_port(struct ib_device *ibdev, u8 port,
 	return err;
 }

-int mlx5_ib_query_port(struct ib_device *ibdev, u8 port,
+int mlx5_ib_query_port(struct ib_device *ibdev, u32 port,
 		       struct ib_port_attr *props)
 {
 	unsigned int count;
@@ -1381,13 +1381,13 @@ int mlx5_ib_query_port(struct ib_device *ibdev, u8 port,
 	return ret;
 }

-static int mlx5_ib_rep_query_port(struct ib_device *ibdev, u8 port,
+static int mlx5_ib_rep_query_port(struct ib_device *ibdev, u32 port,
 				  struct ib_port_attr *props)
 {
 	return mlx5_query_port_roce(ibdev, port, props);
 }

-static int mlx5_ib_rep_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
+static int mlx5_ib_rep_query_pkey(struct ib_device *ibdev, u32 port, u16 index,
 				  u16 *pkey)
 {
 	/* Default special Pkey for representor device port as per the
@@ -1397,7 +1397,7 @@ static int mlx5_ib_rep_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
 	return 0;
 }

-static int mlx5_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
+static int mlx5_ib_query_gid(struct ib_device *ibdev, u32 port, int index,
 			     union ib_gid *gid)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
@@ -1416,13 +1416,13 @@ static int mlx5_ib_query_gid(struct ib_device *ibdev, u8 port, int index,

 }

-static int mlx5_query_hca_nic_pkey(struct ib_device *ibdev, u8 port,
+static int mlx5_query_hca_nic_pkey(struct ib_device *ibdev, u32 port,
 				   u16 index, u16 *pkey)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	struct mlx5_core_dev *mdev;
 	bool put_mdev = true;
-	u8 mdev_port_num;
+	u32 mdev_port_num;
 	int err;

 	mdev = mlx5_ib_get_native_port_mdev(dev, port, &mdev_port_num);
@@ -1443,7 +1443,7 @@ static int mlx5_query_hca_nic_pkey(struct ib_device *ibdev, u8 port,
 	return err;
 }

-static int mlx5_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
+static int mlx5_ib_query_pkey(struct ib_device *ibdev, u32 port, u16 index,
 			      u16 *pkey)
 {
 	switch (mlx5_get_vport_access_method(ibdev)) {
@@ -1487,12 +1487,12 @@ static int mlx5_ib_modify_device(struct ib_device *ibdev, int mask,
 	return err;
 }

-static int set_port_caps_atomic(struct mlx5_ib_dev *dev, u8 port_num, u32 mask,
+static int set_port_caps_atomic(struct mlx5_ib_dev *dev, u32 port_num, u32 mask,
 				u32 value)
 {
 	struct mlx5_hca_vport_context ctx = {};
 	struct mlx5_core_dev *mdev;
-	u8 mdev_port_num;
+	u32 mdev_port_num;
 	int err;

 	mdev = mlx5_ib_get_native_port_mdev(dev, port_num, &mdev_port_num);
@@ -1521,7 +1521,7 @@ static int set_port_caps_atomic(struct mlx5_ib_dev *dev, u8 port_num, u32 mask,
 	return err;
 }

-static int mlx5_ib_modify_port(struct ib_device *ibdev, u8 port, int mask,
+static int mlx5_ib_modify_port(struct ib_device *ibdev, u32 port, int mask,
 			       struct ib_port_modify *props)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
@@ -1930,7 +1930,7 @@ static int mlx5_ib_alloc_ucontext(struct ib_ucontext *uctx,
 	print_lib_caps(dev, context->lib_caps);

 	if (mlx5_ib_lag_should_assign_affinity(dev)) {
-		u8 port = mlx5_core_native_port_num(dev->mdev) - 1;
+		u32 port = mlx5_core_native_port_num(dev->mdev) - 1;

 		atomic_set(&context->tx_port_affinity,
 			   atomic_add_return(
@@ -2780,7 +2780,7 @@ static void delay_drop_handler(struct work_struct *work)
 static void handle_general_event(struct mlx5_ib_dev *ibdev, struct mlx5_eqe *eqe,
 				 struct ib_event *ibev)
 {
-	u8 port = (eqe->data.port.port >> 4) & 0xf;
+	u32 port = (eqe->data.port.port >> 4) & 0xf;

 	switch (eqe->sub_type) {
 	case MLX5_GENERAL_SUBTYPE_DELAY_DROP_TIMEOUT:
@@ -2796,7 +2796,7 @@ static void handle_general_event(struct mlx5_ib_dev *ibdev, struct mlx5_eqe *eqe
 static int handle_port_change(struct mlx5_ib_dev *ibdev, struct mlx5_eqe *eqe,
 			      struct ib_event *ibev)
 {
-	u8 port = (eqe->data.port.port >> 4) & 0xf;
+	u32 port = (eqe->data.port.port >> 4) & 0xf;

 	ibev->element.port_num = port;

@@ -3153,7 +3153,7 @@ static u32 get_core_cap_flags(struct ib_device *ibdev,
 	return ret;
 }

-static int mlx5_port_immutable(struct ib_device *ibdev, u8 port_num,
+static int mlx5_port_immutable(struct ib_device *ibdev, u32 port_num,
 			       struct ib_port_immutable *immutable)
 {
 	struct ib_port_attr attr;
@@ -3181,7 +3181,7 @@ static int mlx5_port_immutable(struct ib_device *ibdev, u8 port_num,
 	return 0;
 }

-static int mlx5_port_rep_immutable(struct ib_device *ibdev, u8 port_num,
+static int mlx5_port_rep_immutable(struct ib_device *ibdev, u32 port_num,
 				   struct ib_port_immutable *immutable)
 {
 	struct ib_port_attr attr;
@@ -3253,7 +3253,7 @@ static void mlx5_eth_lag_cleanup(struct mlx5_ib_dev *dev)
 	}
 }

-static int mlx5_add_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)
+static int mlx5_add_netdev_notifier(struct mlx5_ib_dev *dev, u32 port_num)
 {
 	int err;

@@ -3267,7 +3267,7 @@ static int mlx5_add_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)
 	return 0;
 }

-static void mlx5_remove_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)
+static void mlx5_remove_netdev_notifier(struct mlx5_ib_dev *dev, u32 port_num)
 {
 	if (dev->port[port_num].roce.nb.notifier_call) {
 		unregister_netdevice_notifier(&dev->port[port_num].roce.nb);
@@ -3301,7 +3301,7 @@ static void mlx5_disable_eth(struct mlx5_ib_dev *dev)
 	mlx5_nic_vport_disable_roce(dev->mdev);
 }

-static int mlx5_ib_rn_get_params(struct ib_device *device, u8 port_num,
+static int mlx5_ib_rn_get_params(struct ib_device *device, u32 port_num,
 				 enum rdma_netdev_t type,
 				 struct rdma_netdev_alloc_params *params)
 {
@@ -3353,7 +3353,7 @@ static const struct file_operations fops_delay_drop_timeout = {
 static void mlx5_ib_unbind_slave_port(struct mlx5_ib_dev *ibdev,
 				      struct mlx5_ib_multiport_info *mpi)
 {
-	u8 port_num = mlx5_core_native_port_num(mpi->mdev) - 1;
+	u32 port_num = mlx5_core_native_port_num(mpi->mdev) - 1;
 	struct mlx5_ib_port *port = &ibdev->port[port_num];
 	int comps;
 	int err;
@@ -3399,7 +3399,7 @@ static void mlx5_ib_unbind_slave_port(struct mlx5_ib_dev *ibdev,

 	err = mlx5_nic_vport_unaffiliate_multiport(mpi->mdev);

-	mlx5_ib_dbg(ibdev, "unaffiliated port %d\n", port_num + 1);
+	mlx5_ib_dbg(ibdev, "unaffiliated port %u\n", port_num + 1);
 	/* Log an error, still needed to cleanup the pointers and add
 	 * it back to the list.
 	 */
@@ -3413,14 +3413,14 @@ static void mlx5_ib_unbind_slave_port(struct mlx5_ib_dev *ibdev,
 static bool mlx5_ib_bind_slave_port(struct mlx5_ib_dev *ibdev,
 				    struct mlx5_ib_multiport_info *mpi)
 {
-	u8 port_num = mlx5_core_native_port_num(mpi->mdev) - 1;
+	u32 port_num = mlx5_core_native_port_num(mpi->mdev) - 1;
 	int err;

 	lockdep_assert_held(&mlx5_ib_multiport_mutex);

 	spin_lock(&ibdev->port[port_num].mp.mpi_lock);
 	if (ibdev->port[port_num].mp.mpi) {
-		mlx5_ib_dbg(ibdev, "port %d already affiliated.\n",
+		mlx5_ib_dbg(ibdev, "port %u already affiliated.\n",
 			    port_num + 1);
 		spin_unlock(&ibdev->port[port_num].mp.mpi_lock);
 		return false;
@@ -3456,12 +3456,12 @@ static bool mlx5_ib_bind_slave_port(struct mlx5_ib_dev *ibdev,

 static int mlx5_ib_init_multiport_master(struct mlx5_ib_dev *dev)
 {
-	int port_num = mlx5_core_native_port_num(dev->mdev) - 1;
+	u32 port_num = mlx5_core_native_port_num(dev->mdev) - 1;
 	enum rdma_link_layer ll = mlx5_ib_port_link_layer(&dev->ib_dev,
 							  port_num + 1);
 	struct mlx5_ib_multiport_info *mpi;
 	int err;
-	int i;
+	u32 i;

 	if (!mlx5_core_is_mp_master(dev->mdev) || ll != IB_LINK_LAYER_ETHERNET)
 		return 0;
@@ -3524,10 +3524,10 @@ static int mlx5_ib_init_multiport_master(struct mlx5_ib_dev *dev)

 static void mlx5_ib_cleanup_multiport_master(struct mlx5_ib_dev *dev)
 {
-	int port_num = mlx5_core_native_port_num(dev->mdev) - 1;
+	u32 port_num = mlx5_core_native_port_num(dev->mdev) - 1;
 	enum rdma_link_layer ll = mlx5_ib_port_link_layer(&dev->ib_dev,
 							  port_num + 1);
-	int i;
+	u32 i;

 	if (!mlx5_core_is_mp_master(dev->mdev) || ll != IB_LINK_LAYER_ETHERNET)
 		return;
@@ -3540,7 +3540,8 @@ static void mlx5_ib_cleanup_multiport_master(struct mlx5_ib_dev *dev)
 				kfree(dev->port[i].mp.mpi);
 				dev->port[i].mp.mpi = NULL;
 			} else {
-				mlx5_ib_dbg(dev, "unbinding port_num: %d\n", i + 1);
+				mlx5_ib_dbg(dev, "unbinding port_num: %u\n",
+					    i + 1);
 				mlx5_ib_unbind_slave_port(dev, dev->port[i].mp.mpi);
 			}
 		}
@@ -4161,7 +4162,7 @@ static int mlx5_ib_roce_init(struct mlx5_ib_dev *dev)
 	struct mlx5_core_dev *mdev = dev->mdev;
 	enum rdma_link_layer ll;
 	int port_type_cap;
-	u8 port_num = 0;
+	u32 port_num = 0;
 	int err;

 	port_type_cap = MLX5_CAP_GEN(mdev, port_type);
@@ -4198,7 +4199,7 @@ static void mlx5_ib_roce_cleanup(struct mlx5_ib_dev *dev)
 	struct mlx5_core_dev *mdev = dev->mdev;
 	enum rdma_link_layer ll;
 	int port_type_cap;
-	u8 port_num;
+	u32 port_num;

 	port_type_cap = MLX5_CAP_GEN(mdev, port_type);
 	ll = mlx5_port_type_cap_to_rdma_ll(port_type_cap);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 88cc26e008fc..a2cee68a8390 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -406,7 +406,7 @@ struct mlx5_ib_qp_base {
 struct mlx5_ib_qp_trans {
 	struct mlx5_ib_qp_base	base;
 	u16			xrcdn;
-	u8			alt_port;
+	u32			alt_port;
 	u8			atomic_rd_en;
 	u8			resp_depth;
 };
@@ -453,7 +453,7 @@ struct mlx5_ib_dct {

 struct mlx5_ib_gsi_qp {
 	struct ib_qp *rx_qp;
-	u8 port_num;
+	u32 port_num;
 	struct ib_qp_cap cap;
 	struct ib_cq *cq;
 	struct mlx5_ib_gsi_wr *outstanding_wrs;
@@ -490,7 +490,7 @@ struct mlx5_ib_qp {
 	struct mutex		mutex;
 	/* cached variant of create_flags from struct ib_qp_init_attr */
 	u32			flags;
-	u8			port;
+	u32			port;
 	u8			state;
 	int			max_inline_data;
 	struct mlx5_bf	        bf;
@@ -822,7 +822,7 @@ struct mlx5_roce {
 	atomic_t		tx_port_affinity;
 	enum ib_port_state last_port_state;
 	struct mlx5_ib_dev	*dev;
-	u8			native_port_num;
+	u32			native_port_num;
 };

 struct mlx5_ib_port {
@@ -837,7 +837,7 @@ struct mlx5_ib_dbg_param {
 	int			offset;
 	struct mlx5_ib_dev	*dev;
 	struct dentry		*dentry;
-	u8			port_num;
+	u32			port_num;
 };

 enum mlx5_ib_dbg_cc_types {
@@ -1285,7 +1285,7 @@ int mlx5_ib_map_mr_sg_pi(struct ib_mr *ibmr, struct scatterlist *data_sg,
 			 int data_sg_nents, unsigned int *data_sg_offset,
 			 struct scatterlist *meta_sg, int meta_sg_nents,
 			 unsigned int *meta_sg_offset);
-int mlx5_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
+int mlx5_ib_process_mad(struct ib_device *ibdev, int mad_flags, u32 port_num,
 			const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 			const struct ib_mad *in, struct ib_mad *out,
 			size_t *out_mad_size, u16 *out_mad_pkey_index);
@@ -1300,13 +1300,13 @@ int mlx5_query_mad_ifc_vendor_id(struct ib_device *ibdev,
 				 u32 *vendor_id);
 int mlx5_query_mad_ifc_node_desc(struct mlx5_ib_dev *dev, char *node_desc);
 int mlx5_query_mad_ifc_node_guid(struct mlx5_ib_dev *dev, __be64 *node_guid);
-int mlx5_query_mad_ifc_pkey(struct ib_device *ibdev, u8 port, u16 index,
+int mlx5_query_mad_ifc_pkey(struct ib_device *ibdev, u32 port, u16 index,
 			    u16 *pkey);
-int mlx5_query_mad_ifc_gids(struct ib_device *ibdev, u8 port, int index,
+int mlx5_query_mad_ifc_gids(struct ib_device *ibdev, u32 port, int index,
 			    union ib_gid *gid);
-int mlx5_query_mad_ifc_port(struct ib_device *ibdev, u8 port,
+int mlx5_query_mad_ifc_port(struct ib_device *ibdev, u32 port,
 			    struct ib_port_attr *props);
-int mlx5_ib_query_port(struct ib_device *ibdev, u8 port,
+int mlx5_ib_query_port(struct ib_device *ibdev, u32 port,
 		       struct ib_port_attr *props);
 void mlx5_ib_populate_pas(struct ib_umem *umem, size_t page_size, __be64 *pas,
 			  u64 access_flags);
@@ -1397,22 +1397,22 @@ int __mlx5_ib_add(struct mlx5_ib_dev *dev,
 		  const struct mlx5_ib_profile *profile);

 int mlx5_ib_get_vf_config(struct ib_device *device, int vf,
-			  u8 port, struct ifla_vf_info *info);
+			  u32 port, struct ifla_vf_info *info);
 int mlx5_ib_set_vf_link_state(struct ib_device *device, int vf,
-			      u8 port, int state);
+			      u32 port, int state);
 int mlx5_ib_get_vf_stats(struct ib_device *device, int vf,
-			 u8 port, struct ifla_vf_stats *stats);
-int mlx5_ib_get_vf_guid(struct ib_device *device, int vf, u8 port,
+			 u32 port, struct ifla_vf_stats *stats);
+int mlx5_ib_get_vf_guid(struct ib_device *device, int vf, u32 port,
 			struct ifla_vf_guid *node_guid,
 			struct ifla_vf_guid *port_guid);
-int mlx5_ib_set_vf_guid(struct ib_device *device, int vf, u8 port,
+int mlx5_ib_set_vf_guid(struct ib_device *device, int vf, u32 port,
 			u64 guid, int type);

 __be16 mlx5_get_roce_udp_sport_min(const struct mlx5_ib_dev *dev,
 				   const struct ib_gid_attr *attr);

-void mlx5_ib_cleanup_cong_debugfs(struct mlx5_ib_dev *dev, u8 port_num);
-void mlx5_ib_init_cong_debugfs(struct mlx5_ib_dev *dev, u8 port_num);
+void mlx5_ib_cleanup_cong_debugfs(struct mlx5_ib_dev *dev, u32 port_num);
+void mlx5_ib_init_cong_debugfs(struct mlx5_ib_dev *dev, u32 port_num);

 /* GSI QP helper functions */
 int mlx5_ib_create_gsi(struct ib_pd *pd, struct mlx5_ib_qp *mqp,
@@ -1435,10 +1435,10 @@ void mlx5_ib_free_bfreg(struct mlx5_ib_dev *dev, struct mlx5_bfreg_info *bfregi,
 			int bfregn);
 struct mlx5_ib_dev *mlx5_ib_get_ibdev_from_mpi(struct mlx5_ib_multiport_info *mpi);
 struct mlx5_core_dev *mlx5_ib_get_native_port_mdev(struct mlx5_ib_dev *dev,
-						   u8 ib_port_num,
-						   u8 *native_port_num);
+						   u32 ib_port_num,
+						   u32 *native_port_num);
 void mlx5_ib_put_native_port_mdev(struct mlx5_ib_dev *dev,
-				  u8 port_num);
+				  u32 port_num);

 extern const struct uapi_definition mlx5_ib_devx_defs[];
 extern const struct uapi_definition mlx5_ib_flow_defs[];
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index ec4b3f6a8222..669716425e83 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -67,7 +67,7 @@ struct mlx5_modify_raw_qp_param {
 	struct mlx5_rate_limit rl;

 	u8 rq_q_ctr_id;
-	u16 port;
+	u32 port;
 };

 static void get_cqs(enum ib_qp_type qp_type,
diff --git a/drivers/infiniband/hw/mthca/mthca_av.c b/drivers/infiniband/hw/mthca/mthca_av.c
index f051f4e06b53..3df1f5ff7932 100644
--- a/drivers/infiniband/hw/mthca/mthca_av.c
+++ b/drivers/infiniband/hw/mthca/mthca_av.c
@@ -91,7 +91,7 @@ static enum ib_rate tavor_rate_to_ib(u8 mthca_rate, u8 port_rate)
 	}
 }

-enum ib_rate mthca_rate_to_ib(struct mthca_dev *dev, u8 mthca_rate, u8 port)
+enum ib_rate mthca_rate_to_ib(struct mthca_dev *dev, u8 mthca_rate, u32 port)
 {
 	if (mthca_is_memfree(dev)) {
 		/* Handle old Arbel FW */
@@ -131,7 +131,7 @@ static u8 ib_rate_to_tavor(u8 static_rate)
 	}
 }

-u8 mthca_get_rate(struct mthca_dev *dev, int static_rate, u8 port)
+u8 mthca_get_rate(struct mthca_dev *dev, int static_rate, u32 port)
 {
 	u8 rate;

@@ -293,7 +293,7 @@ int mthca_ah_query(struct ib_ah *ibah, struct rdma_ah_attr *attr)
 {
 	struct mthca_ah *ah   = to_mah(ibah);
 	struct mthca_dev *dev = to_mdev(ibah->device);
-	u8 port_num = be32_to_cpu(ah->av->port_pd) >> 24;
+	u32 port_num = be32_to_cpu(ah->av->port_pd) >> 24;

 	/* Only implement for MAD and memfree ah for now. */
 	if (ah->type == MTHCA_AH_ON_HCA)
diff --git a/drivers/infiniband/hw/mthca/mthca_dev.h b/drivers/infiniband/hw/mthca/mthca_dev.h
index a445160de3e1..a4a9d871d00e 100644
--- a/drivers/infiniband/hw/mthca/mthca_dev.h
+++ b/drivers/infiniband/hw/mthca/mthca_dev.h
@@ -546,7 +546,7 @@ int mthca_alloc_sqp(struct mthca_dev *dev,
 		    enum ib_sig_type send_policy,
 		    struct ib_qp_cap *cap,
 		    int qpn,
-		    int port,
+		    u32 port,
 		    struct mthca_qp *qp,
 		    struct ib_udata *udata);
 void mthca_free_qp(struct mthca_dev *dev, struct mthca_qp *qp);
@@ -559,13 +559,13 @@ int mthca_read_ah(struct mthca_dev *dev, struct mthca_ah *ah,
 		  struct ib_ud_header *header);
 int mthca_ah_query(struct ib_ah *ibah, struct rdma_ah_attr *attr);
 int mthca_ah_grh_present(struct mthca_ah *ah);
-u8 mthca_get_rate(struct mthca_dev *dev, int static_rate, u8 port);
-enum ib_rate mthca_rate_to_ib(struct mthca_dev *dev, u8 mthca_rate, u8 port);
+u8 mthca_get_rate(struct mthca_dev *dev, int static_rate, u32 port);
+enum ib_rate mthca_rate_to_ib(struct mthca_dev *dev, u8 mthca_rate, u32 port);

 int mthca_multicast_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid);
 int mthca_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid);

-int mthca_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
+int mthca_process_mad(struct ib_device *ibdev, int mad_flags, u32 port_num,
 		      const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 		      const struct ib_mad *in, struct ib_mad *out,
 		      size_t *out_mad_size, u16 *out_mad_pkey_index);
diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index 99aa8183a7f2..04252700790e 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -162,7 +162,7 @@ static void node_desc_override(struct ib_device *dev,
 }

 static void forward_trap(struct mthca_dev *dev,
-			 u8 port_num,
+			 u32 port_num,
 			 const struct ib_mad *mad)
 {
 	int qpn = mad->mad_hdr.mgmt_class != IB_MGMT_CLASS_SUBN_LID_ROUTED;
@@ -196,7 +196,7 @@ static void forward_trap(struct mthca_dev *dev,
 	}
 }

-int mthca_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
+int mthca_process_mad(struct ib_device *ibdev, int mad_flags, u32 port_num,
 		      const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 		      const struct ib_mad *in, struct ib_mad *out,
 		      size_t *out_mad_size, u16 *out_mad_pkey_index)
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 1a3dd07f993b..522bb606120e 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -127,7 +127,7 @@ static int mthca_query_device(struct ib_device *ibdev, struct ib_device_attr *pr
 }

 static int mthca_query_port(struct ib_device *ibdev,
-			    u8 port, struct ib_port_attr *props)
+			    u32 port, struct ib_port_attr *props)
 {
 	struct ib_smp *in_mad  = NULL;
 	struct ib_smp *out_mad = NULL;
@@ -194,7 +194,7 @@ static int mthca_modify_device(struct ib_device *ibdev,
 }

 static int mthca_modify_port(struct ib_device *ibdev,
-			     u8 port, int port_modify_mask,
+			     u32 port, int port_modify_mask,
 			     struct ib_port_modify *props)
 {
 	struct mthca_set_ib_param set_ib;
@@ -223,7 +223,7 @@ static int mthca_modify_port(struct ib_device *ibdev,
 }

 static int mthca_query_pkey(struct ib_device *ibdev,
-			    u8 port, u16 index, u16 *pkey)
+			    u32 port, u16 index, u16 *pkey)
 {
 	struct ib_smp *in_mad  = NULL;
 	struct ib_smp *out_mad = NULL;
@@ -251,7 +251,7 @@ static int mthca_query_pkey(struct ib_device *ibdev,
 	return err;
 }

-static int mthca_query_gid(struct ib_device *ibdev, u8 port,
+static int mthca_query_gid(struct ib_device *ibdev, u32 port,
 			   int index, union ib_gid *gid)
 {
 	struct ib_smp *in_mad  = NULL;
@@ -1051,7 +1051,7 @@ static int mthca_init_node_data(struct mthca_dev *dev)
 	return err;
 }

-static int mthca_port_immutable(struct ib_device *ibdev, u8 port_num,
+static int mthca_port_immutable(struct ib_device *ibdev, u32 port_num,
 			        struct ib_port_immutable *immutable)
 {
 	struct ib_port_attr attr;
diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index 07cfc0934b17..69bba0ef4a5d 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -1370,7 +1370,7 @@ int mthca_alloc_sqp(struct mthca_dev *dev,
 		    enum ib_sig_type send_policy,
 		    struct ib_qp_cap *cap,
 		    int qpn,
-		    int port,
+		    u32 port,
 		    struct mthca_qp *qp,
 		    struct ib_udata *udata)
 {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index 699a8b719ed6..88c45928301f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -250,7 +250,7 @@ int ocrdma_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *attr)
 }

 int ocrdma_process_mad(struct ib_device *ibdev, int process_mad_flags,
-		       u8 port_num, const struct ib_wc *in_wc,
+		       u32 port_num, const struct ib_wc *in_wc,
 		       const struct ib_grh *in_grh, const struct ib_mad *in,
 		       struct ib_mad *out, size_t *out_mad_size,
 		       u16 *out_mad_pkey_index)
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
index 35cf2e2ff391..2626679df31d 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
@@ -57,7 +57,7 @@ int ocrdma_destroy_ah(struct ib_ah *ah, u32 flags);
 int ocrdma_query_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);

 int ocrdma_process_mad(struct ib_device *dev, int process_mad_flags,
-		       u8 port_num, const struct ib_wc *in_wc,
+		       u32 port_num, const struct ib_wc *in_wc,
 		       const struct ib_grh *in_grh, const struct ib_mad *in,
 		       struct ib_mad *out, size_t *out_mad_size,
 		       u16 *out_mad_pkey_index);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 9a834a9cca0e..4882b3156edb 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -77,12 +77,12 @@ void ocrdma_get_guid(struct ocrdma_dev *dev, u8 *guid)
 	guid[7] = mac_addr[5];
 }
 static enum rdma_link_layer ocrdma_link_layer(struct ib_device *device,
-					      u8 port_num)
+					      u32 port_num)
 {
 	return IB_LINK_LAYER_ETHERNET;
 }

-static int ocrdma_port_immutable(struct ib_device *ibdev, u8 port_num,
+static int ocrdma_port_immutable(struct ib_device *ibdev, u32 port_num,
 			         struct ib_port_immutable *immutable)
 {
 	struct ib_port_attr attr;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 3acb5c10b155..58619ce64d0d 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -54,7 +54,7 @@
 #include "ocrdma_verbs.h"
 #include <rdma/ocrdma-abi.h>

-int ocrdma_query_pkey(struct ib_device *ibdev, u8 port, u16 index, u16 *pkey)
+int ocrdma_query_pkey(struct ib_device *ibdev, u32 port, u16 index, u16 *pkey)
 {
 	if (index > 0)
 		return -EINVAL;
@@ -150,7 +150,7 @@ static inline void get_link_speed_and_width(struct ocrdma_dev *dev,
 }

 int ocrdma_query_port(struct ib_device *ibdev,
-		      u8 port, struct ib_port_attr *props)
+		      u32 port, struct ib_port_attr *props)
 {
 	enum ib_port_state port_state;
 	struct ocrdma_dev *dev;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
index 425d554e7f3f..b1c5fad81603 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
@@ -53,13 +53,14 @@ int ocrdma_arm_cq(struct ib_cq *, enum ib_cq_notify_flags flags);

 int ocrdma_query_device(struct ib_device *, struct ib_device_attr *props,
 			struct ib_udata *uhw);
-int ocrdma_query_port(struct ib_device *, u8 port, struct ib_port_attr *props);
+int ocrdma_query_port(struct ib_device *ibdev, u32 port,
+		      struct ib_port_attr *props);

 enum rdma_protocol_type
-ocrdma_query_protocol(struct ib_device *device, u8 port_num);
+ocrdma_query_protocol(struct ib_device *device, u32 port_num);

 void ocrdma_get_guid(struct ocrdma_dev *, u8 *guid);
-int ocrdma_query_pkey(struct ib_device *, u8 port, u16 index, u16 *pkey);
+int ocrdma_query_pkey(struct ib_device *ibdev, u32 port, u16 index, u16 *pkey);

 int ocrdma_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata);
 void ocrdma_dealloc_ucontext(struct ib_ucontext *uctx);
diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index 8e7c069e1a2d..8334a9850220 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -53,7 +53,7 @@ MODULE_LICENSE("Dual BSD/GPL");

 #define QEDR_WQ_MULTIPLIER_DFT	(3)

-static void qedr_ib_dispatch_event(struct qedr_dev *dev, u8 port_num,
+static void qedr_ib_dispatch_event(struct qedr_dev *dev, u32 port_num,
 				   enum ib_event_type type)
 {
 	struct ib_event ibev;
@@ -66,7 +66,7 @@ static void qedr_ib_dispatch_event(struct qedr_dev *dev, u8 port_num,
 }

 static enum rdma_link_layer qedr_link_layer(struct ib_device *device,
-					    u8 port_num)
+					    u32 port_num)
 {
 	return IB_LINK_LAYER_ETHERNET;
 }
@@ -81,7 +81,7 @@ static void qedr_get_dev_fw_str(struct ib_device *ibdev, char *str)
 		 (fw_ver >> 8) & 0xFF, fw_ver & 0xFF);
 }

-static int qedr_roce_port_immutable(struct ib_device *ibdev, u8 port_num,
+static int qedr_roce_port_immutable(struct ib_device *ibdev, u32 port_num,
 				    struct ib_port_immutable *immutable)
 {
 	struct ib_port_attr attr;
@@ -100,7 +100,7 @@ static int qedr_roce_port_immutable(struct ib_device *ibdev, u8 port_num,
 	return 0;
 }

-static int qedr_iw_port_immutable(struct ib_device *ibdev, u8 port_num,
+static int qedr_iw_port_immutable(struct ib_device *ibdev, u32 port_num,
 				  struct ib_port_immutable *immutable)
 {
 	struct ib_port_attr attr;
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 0eb6a7a618e0..41e12f011f22 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -72,7 +72,7 @@ static inline int qedr_ib_copy_to_udata(struct ib_udata *udata, void *src,
 	return ib_copy_to_udata(udata, src, min_len);
 }

-int qedr_query_pkey(struct ib_device *ibdev, u8 port, u16 index, u16 *pkey)
+int qedr_query_pkey(struct ib_device *ibdev, u32 port, u16 index, u16 *pkey)
 {
 	if (index >= QEDR_ROCE_PKEY_TABLE_LEN)
 		return -EINVAL;
@@ -81,7 +81,7 @@ int qedr_query_pkey(struct ib_device *ibdev, u8 port, u16 index, u16 *pkey)
 	return 0;
 }

-int qedr_iw_query_gid(struct ib_device *ibdev, u8 port,
+int qedr_iw_query_gid(struct ib_device *ibdev, u32 port,
 		      int index, union ib_gid *sgid)
 {
 	struct qedr_dev *dev = get_qedr_dev(ibdev);
@@ -210,7 +210,8 @@ static inline void get_link_speed_and_width(int speed, u16 *ib_speed,
 	}
 }

-int qedr_query_port(struct ib_device *ibdev, u8 port, struct ib_port_attr *attr)
+int qedr_query_port(struct ib_device *ibdev, u32 port,
+		    struct ib_port_attr *attr)
 {
 	struct qedr_dev *dev;
 	struct qed_rdma_port *rdma_port;
@@ -4482,7 +4483,7 @@ int qedr_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 }

 int qedr_process_mad(struct ib_device *ibdev, int process_mad_flags,
-		     u8 port_num, const struct ib_wc *in_wc,
+		     u32 port_num, const struct ib_wc *in_wc,
 		     const struct ib_grh *in_grh, const struct ib_mad *in,
 		     struct ib_mad *out_mad, size_t *out_mad_size,
 		     u16 *out_mad_pkey_index)
diff --git a/drivers/infiniband/hw/qedr/verbs.h b/drivers/infiniband/hw/qedr/verbs.h
index 2672c32bc2f7..34ad47515861 100644
--- a/drivers/infiniband/hw/qedr/verbs.h
+++ b/drivers/infiniband/hw/qedr/verbs.h
@@ -34,12 +34,13 @@

 int qedr_query_device(struct ib_device *ibdev,
 		      struct ib_device_attr *attr, struct ib_udata *udata);
-int qedr_query_port(struct ib_device *, u8 port, struct ib_port_attr *props);
+int qedr_query_port(struct ib_device *ibdev, u32 port,
+		    struct ib_port_attr *props);

-int qedr_iw_query_gid(struct ib_device *ibdev, u8 port,
+int qedr_iw_query_gid(struct ib_device *ibdev, u32 port,
 		      int index, union ib_gid *gid);

-int qedr_query_pkey(struct ib_device *, u8 port, u16 index, u16 *pkey);
+int qedr_query_pkey(struct ib_device *ibdev, u32 port, u16 index, u16 *pkey);

 int qedr_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata);
 void qedr_dealloc_ucontext(struct ib_ucontext *uctx);
@@ -92,11 +93,11 @@ int qedr_post_send(struct ib_qp *, const struct ib_send_wr *,
 int qedr_post_recv(struct ib_qp *, const struct ib_recv_wr *,
 		   const struct ib_recv_wr **bad_wr);
 int qedr_process_mad(struct ib_device *ibdev, int process_mad_flags,
-		     u8 port_num, const struct ib_wc *in_wc,
+		     u32 port_num, const struct ib_wc *in_wc,
 		     const struct ib_grh *in_grh, const struct ib_mad *in_mad,
 		     struct ib_mad *out_mad, size_t *out_mad_size,
 		     u16 *out_mad_pkey_index);

-int qedr_port_immutable(struct ib_device *ibdev, u8 port_num,
+int qedr_port_immutable(struct ib_device *ibdev, u32 port_num,
 			struct ib_port_immutable *immutable);
 #endif
diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index ee211423058a..9b13f668b31f 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -630,7 +630,7 @@ struct qib_pportdata {
 	u8 rx_pol_inv;

 	u8 hw_pidx;     /* physical port index */
-	u8 port;        /* IB port number and index into dd->pports - 1 */
+	u32 port;        /* IB port number and index into dd->pports - 1 */

 	u8 delay_mult;

@@ -1200,10 +1200,10 @@ static inline struct qib_pportdata *ppd_from_ibp(struct qib_ibport *ibp)
 	return container_of(ibp, struct qib_pportdata, ibport_data);
 }

-static inline struct qib_ibport *to_iport(struct ib_device *ibdev, u8 port)
+static inline struct qib_ibport *to_iport(struct ib_device *ibdev, u32 port)
 {
 	struct qib_devdata *dd = dd_from_ibdev(ibdev);
-	unsigned pidx = port - 1; /* IB number port from 1, hdw from 0 */
+	u32 pidx = port - 1; /* IB number port from 1, hdw from 0 */

 	WARN_ON(pidx >= dd->num_pports);
 	return &dd->pport[pidx].ibport_data;
@@ -1395,7 +1395,7 @@ extern const struct attribute_group qib_attr_group;
 int qib_device_create(struct qib_devdata *);
 void qib_device_remove(struct qib_devdata *);

-int qib_create_port_files(struct ib_device *ibdev, u8 port_num,
+int qib_create_port_files(struct ib_device *ibdev, u32 port_num,
 			  struct kobject *kobj);
 void qib_verbs_unregister_sysfs(struct qib_devdata *);
 /* Hook for sysfs read of QSFP */
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 44e2f813024a..ef02f2bfddb2 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -203,7 +203,7 @@ static void qib_bad_mkey(struct qib_ibport *ibp, struct ib_smp *smp)
 /*
  * Send a Port Capability Mask Changed trap (ch. 14.3.11).
  */
-void qib_cap_mask_chg(struct rvt_dev_info *rdi, u8 port_num)
+void qib_cap_mask_chg(struct rvt_dev_info *rdi, u32 port_num)
 {
 	struct qib_ibdev *ibdev = container_of(rdi, struct qib_ibdev, rdi);
 	struct qib_devdata *dd = dd_from_dev(ibdev);
@@ -2360,7 +2360,7 @@ static int process_cc(struct ib_device *ibdev, int mad_flags,
  *
  * This is called by the ib_mad module.
  */
-int qib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
+int qib_process_mad(struct ib_device *ibdev, int mad_flags, u32 port,
 		    const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 		    const struct ib_mad *in, struct ib_mad *out,
 		    size_t *out_mad_size, u16 *out_mad_pkey_index)
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index ca39a029e4af..1974ceb9d405 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -125,7 +125,7 @@ static void get_map_page(struct rvt_qpn_table *qpt, struct rvt_qpn_map *map)
  * zero/one for QP type IB_QPT_SMI/IB_QPT_GSI.
  */
 int qib_alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
-		  enum ib_qp_type type, u8 port)
+		  enum ib_qp_type type, u32 port)
 {
 	u32 i, offset, max_scan, qpn;
 	struct rvt_qpn_map *map;
@@ -136,7 +136,7 @@ int qib_alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
 	u16 qpt_mask = dd->qpn_mask;

 	if (type == IB_QPT_SMI || type == IB_QPT_GSI) {
-		unsigned n;
+		u32 n;

 		ret = type == IB_QPT_GSI;
 		n = 1 << (ret + 2 * (port - 1));
diff --git a/drivers/infiniband/hw/qib/qib_sysfs.c b/drivers/infiniband/hw/qib/qib_sysfs.c
index 62c179fc764b..5e9e66f27064 100644
--- a/drivers/infiniband/hw/qib/qib_sysfs.c
+++ b/drivers/infiniband/hw/qib/qib_sysfs.c
@@ -728,7 +728,7 @@ const struct attribute_group qib_attr_group = {
 	.attrs = qib_attributes,
 };

-int qib_create_port_files(struct ib_device *ibdev, u8 port_num,
+int qib_create_port_files(struct ib_device *ibdev, u32 port_num,
 			  struct kobject *kobj)
 {
 	struct qib_pportdata *ppd;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 8e0de265ad57..d17d034ecdfd 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1188,7 +1188,7 @@ void qib_ib_piobufavail(struct qib_devdata *dd)
 	}
 }

-static int qib_query_port(struct rvt_dev_info *rdi, u8 port_num,
+static int qib_query_port(struct rvt_dev_info *rdi, u32 port_num,
 			  struct ib_port_attr *props)
 {
 	struct qib_ibdev *ibdev = container_of(rdi, struct qib_ibdev, rdi);
@@ -1273,7 +1273,7 @@ static int qib_modify_device(struct ib_device *device,
 	return ret;
 }

-static int qib_shut_down_port(struct rvt_dev_info *rdi, u8 port_num)
+static int qib_shut_down_port(struct rvt_dev_info *rdi, u32 port_num)
 {
 	struct qib_ibdev *ibdev = container_of(rdi, struct qib_ibdev, rdi);
 	struct qib_devdata *dd = dd_from_dev(ibdev);
@@ -1342,7 +1342,7 @@ struct ib_ah *qib_create_qp0_ah(struct qib_ibport *ibp, u16 dlid)
 	struct rvt_qp *qp0;
 	struct qib_pportdata *ppd = ppd_from_ibp(ibp);
 	struct qib_devdata *dd = dd_from_ppd(ppd);
-	u8 port_num = ppd->port;
+	u32 port_num = ppd->port;

 	memset(&attr, 0, sizeof(attr));
 	attr.type = rdma_ah_find_type(&dd->verbs_dev.rdi.ibdev, port_num);
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index dc0e81f3b6f4..07548fac1d8e 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -239,10 +239,10 @@ static inline int qib_pkey_ok(u16 pkey1, u16 pkey2)

 void qib_bad_pkey(struct qib_ibport *ibp, u32 key, u32 sl,
 		  u32 qp1, u32 qp2, __be16 lid1, __be16 lid2);
-void qib_cap_mask_chg(struct rvt_dev_info *rdi, u8 port_num);
+void qib_cap_mask_chg(struct rvt_dev_info *rdi, u32 port_num);
 void qib_sys_guid_chg(struct qib_ibport *ibp);
 void qib_node_desc_chg(struct qib_ibport *ibp);
-int qib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
+int qib_process_mad(struct ib_device *ibdev, int mad_flags, u32 port_num,
 		    const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 		    const struct ib_mad *in, struct ib_mad *out,
 		    size_t *out_mad_size, u16 *out_mad_pkey_index);
@@ -273,7 +273,7 @@ void *qib_qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp);
 void qib_qp_priv_free(struct rvt_dev_info *rdi, struct rvt_qp *qp);
 void qib_notify_qp_reset(struct rvt_qp *qp);
 int qib_alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
-		  enum ib_qp_type type, u8 port);
+		  enum ib_qp_type type, u32 port);
 void qib_restart_rc(struct rvt_qp *qp, u32 psn, int wait);
 #ifdef CONFIG_DEBUG_FS

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index 1b63a491fa72..ff6a40e259d5 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -303,7 +303,7 @@ static struct notifier_block usnic_ib_inetaddr_notifier = {
 };
 /* End of inet section*/

-static int usnic_port_immutable(struct ib_device *ibdev, u8 port_num,
+static int usnic_port_immutable(struct ib_device *ibdev, u32 port_num,
 			        struct ib_port_immutable *immutable)
 {
 	struct ib_port_attr attr;
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 3705c6b8b223..57d210ca855a 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -270,7 +270,7 @@ static int create_qp_validate_user_data(struct usnic_ib_create_qp_cmd cmd)
 /* Start of ib callback functions */

 enum rdma_link_layer usnic_ib_port_link_layer(struct ib_device *device,
-						u8 port_num)
+					      u32 port_num)
 {
 	return IB_LINK_LAYER_ETHERNET;
 }
@@ -332,7 +332,7 @@ int usnic_ib_query_device(struct ib_device *ibdev,
 	return 0;
 }

-int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
+int usnic_ib_query_port(struct ib_device *ibdev, u32 port,
 				struct ib_port_attr *props)
 {
 	struct usnic_ib_dev *us_ibdev = to_usdev(ibdev);
@@ -420,7 +420,7 @@ int usnic_ib_query_qp(struct ib_qp *qp, struct ib_qp_attr *qp_attr,
 	return err;
 }

-int usnic_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
+int usnic_ib_query_gid(struct ib_device *ibdev, u32 port, int index,
 				union ib_gid *gid)
 {

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
index 11fe1ba6bbc9..6b82d0f2d184 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
@@ -37,16 +37,16 @@
 #include "usnic_ib.h"

 enum rdma_link_layer usnic_ib_port_link_layer(struct ib_device *device,
-						u8 port_num);
+					      u32 port_num);
 int usnic_ib_query_device(struct ib_device *ibdev,
 				struct ib_device_attr *props,
 			  struct ib_udata *uhw);
-int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
+int usnic_ib_query_port(struct ib_device *ibdev, u32 port,
 				struct ib_port_attr *props);
 int usnic_ib_query_qp(struct ib_qp *qp, struct ib_qp_attr *qp_attr,
 				int qp_attr_mask,
 				struct ib_qp_init_attr *qp_init_attr);
-int usnic_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
+int usnic_ib_query_gid(struct ib_device *ibdev, u32 port, int index,
 				union ib_gid *gid);
 int usnic_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata);
 int usnic_ib_dealloc_pd(struct ib_pd *pd, struct ib_udata *udata);
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index 4b6019e7de67..6bf2d2e47d07 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -121,7 +121,7 @@ static int pvrdma_init_device(struct pvrdma_dev *dev)
 	return 0;
 }

-static int pvrdma_port_immutable(struct ib_device *ibdev, u8 port_num,
+static int pvrdma_port_immutable(struct ib_device *ibdev, u32 port_num,
 				 struct ib_port_immutable *immutable)
 {
 	struct pvrdma_dev *dev = to_vdev(ibdev);
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
index fc412cbfd042..19176583dbde 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
@@ -125,7 +125,7 @@ int pvrdma_query_device(struct ib_device *ibdev,
  *
  * @return: 0 on success, otherwise negative errno
  */
-int pvrdma_query_port(struct ib_device *ibdev, u8 port,
+int pvrdma_query_port(struct ib_device *ibdev, u32 port,
 		      struct ib_port_attr *props)
 {
 	struct pvrdma_dev *dev = to_vdev(ibdev);
@@ -183,7 +183,7 @@ int pvrdma_query_port(struct ib_device *ibdev, u8 port,
  *
  * @return: 0 on success, otherwise negative errno
  */
-int pvrdma_query_gid(struct ib_device *ibdev, u8 port, int index,
+int pvrdma_query_gid(struct ib_device *ibdev, u32 port, int index,
 		     union ib_gid *gid)
 {
 	struct pvrdma_dev *dev = to_vdev(ibdev);
@@ -205,7 +205,7 @@ int pvrdma_query_gid(struct ib_device *ibdev, u8 port, int index,
  *
  * @return: 0 on success, otherwise negative errno
  */
-int pvrdma_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
+int pvrdma_query_pkey(struct ib_device *ibdev, u32 port, u16 index,
 		      u16 *pkey)
 {
 	int err = 0;
@@ -232,7 +232,7 @@ int pvrdma_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
 }

 enum rdma_link_layer pvrdma_port_link_layer(struct ib_device *ibdev,
-					    u8 port)
+					    u32 port)
 {
 	return IB_LINK_LAYER_ETHERNET;
 }
@@ -274,7 +274,7 @@ int pvrdma_modify_device(struct ib_device *ibdev, int mask,
  *
  * @return: 0 on success, otherwise negative errno
  */
-int pvrdma_modify_port(struct ib_device *ibdev, u8 port, int mask,
+int pvrdma_modify_port(struct ib_device *ibdev, u32 port, int mask,
 		       struct ib_port_modify *props)
 {
 	struct ib_port_attr attr;
@@ -516,7 +516,7 @@ int pvrdma_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
 	struct pvrdma_dev *dev = to_vdev(ibah->device);
 	struct pvrdma_ah *ah = to_vah(ibah);
 	const struct ib_global_route *grh;
-	u8 port_num = rdma_ah_get_port_num(ah_attr);
+	u32 port_num = rdma_ah_get_port_num(ah_attr);

 	if (!(rdma_ah_get_ah_flags(ah_attr) & IB_AH_GRH))
 		return -EINVAL;
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
index 97ed8f952f6e..e28525a8c275 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
@@ -383,17 +383,17 @@ enum pvrdma_access_flags {
 int pvrdma_query_device(struct ib_device *ibdev,
 			struct ib_device_attr *props,
 			struct ib_udata *udata);
-int pvrdma_query_port(struct ib_device *ibdev, u8 port,
+int pvrdma_query_port(struct ib_device *ibdev, u32 port,
 		      struct ib_port_attr *props);
-int pvrdma_query_gid(struct ib_device *ibdev, u8 port,
+int pvrdma_query_gid(struct ib_device *ibdev, u32 port,
 		     int index, union ib_gid *gid);
-int pvrdma_query_pkey(struct ib_device *ibdev, u8 port,
+int pvrdma_query_pkey(struct ib_device *ibdev, u32 port,
 		      u16 index, u16 *pkey);
 enum rdma_link_layer pvrdma_port_link_layer(struct ib_device *ibdev,
-					    u8 port);
+					    u32 port);
 int pvrdma_modify_device(struct ib_device *ibdev, int mask,
 			 struct ib_device_modify *props);
-int pvrdma_modify_port(struct ib_device *ibdev, u8 port,
+int pvrdma_modify_port(struct ib_device *ibdev, u32 port,
 		       int mask, struct ib_port_modify *props);
 int pvrdma_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
 int pvrdma_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata);
diff --git a/drivers/infiniband/sw/rdmavt/mad.c b/drivers/infiniband/sw/rdmavt/mad.c
index fa5be13a4394..207bc0ed96ff 100644
--- a/drivers/infiniband/sw/rdmavt/mad.c
+++ b/drivers/infiniband/sw/rdmavt/mad.c
@@ -70,7 +70,7 @@
  *
  * Return: IB_MAD_RESULT_SUCCESS or error
  */
-int rvt_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
+int rvt_process_mad(struct ib_device *ibdev, int mad_flags, u32 port_num,
 		    const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 		    const struct ib_mad_hdr *in, size_t in_mad_size,
 		    struct ib_mad_hdr *out, size_t *out_mad_size,
@@ -82,9 +82,6 @@ int rvt_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 	 * future may choose to implement this but it should not be made into a
 	 * requirement.
 	 */
-	if (ibport_num_to_idx(ibdev, port_num) < 0)
-		return -EINVAL;
-
 	return IB_MAD_RESULT_FAILURE;
 }

diff --git a/drivers/infiniband/sw/rdmavt/mad.h b/drivers/infiniband/sw/rdmavt/mad.h
index a9d6eecc3723..1eae5efea4be 100644
--- a/drivers/infiniband/sw/rdmavt/mad.h
+++ b/drivers/infiniband/sw/rdmavt/mad.h
@@ -50,7 +50,7 @@

 #include <rdma/rdma_vt.h>

-int rvt_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
+int rvt_process_mad(struct ib_device *ibdev, int mad_flags, u32 port_num,
 		    const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 		    const struct ib_mad_hdr *in, size_t in_mad_size,
 		    struct ib_mad_hdr *out, size_t *out_mad_size,
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 8fd0128a9336..12ebe041a5da 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -151,15 +151,12 @@ static int rvt_modify_device(struct ib_device *device,
  *
  * Return: 0 on success
  */
-static int rvt_query_port(struct ib_device *ibdev, u8 port_num,
+static int rvt_query_port(struct ib_device *ibdev, u32 port_num,
 			  struct ib_port_attr *props)
 {
 	struct rvt_dev_info *rdi = ib_to_rvt(ibdev);
 	struct rvt_ibport *rvp;
-	int port_index = ibport_num_to_idx(ibdev, port_num);
-
-	if (port_index < 0)
-		return -EINVAL;
+	u32 port_index = ibport_num_to_idx(ibdev, port_num);

 	rvp = rdi->ports[port_index];
 	/* props being zeroed by the caller, avoid zeroing it here */
@@ -186,16 +183,13 @@ static int rvt_query_port(struct ib_device *ibdev, u8 port_num,
  *
  * Return: 0 on success
  */
-static int rvt_modify_port(struct ib_device *ibdev, u8 port_num,
+static int rvt_modify_port(struct ib_device *ibdev, u32 port_num,
 			   int port_modify_mask, struct ib_port_modify *props)
 {
 	struct rvt_dev_info *rdi = ib_to_rvt(ibdev);
 	struct rvt_ibport *rvp;
 	int ret = 0;
-	int port_index = ibport_num_to_idx(ibdev, port_num);
-
-	if (port_index < 0)
-		return -EINVAL;
+	u32 port_index = ibport_num_to_idx(ibdev, port_num);

 	rvp = rdi->ports[port_index];
 	if (port_modify_mask & IB_PORT_OPA_MASK_CHG) {
@@ -225,7 +219,7 @@ static int rvt_modify_port(struct ib_device *ibdev, u8 port_num,
  *
  * Return: 0 on failure pkey otherwise
  */
-static int rvt_query_pkey(struct ib_device *ibdev, u8 port_num, u16 index,
+static int rvt_query_pkey(struct ib_device *ibdev, u32 port_num, u16 index,
 			  u16 *pkey)
 {
 	/*
@@ -235,11 +229,9 @@ static int rvt_query_pkey(struct ib_device *ibdev, u8 port_num, u16 index,
 	 * no way to protect against that anyway.
 	 */
 	struct rvt_dev_info *rdi = ib_to_rvt(ibdev);
-	int port_index;
+	u32 port_index;

 	port_index = ibport_num_to_idx(ibdev, port_num);
-	if (port_index < 0)
-		return -EINVAL;

 	if (index >= rvt_get_npkeys(rdi))
 		return -EINVAL;
@@ -257,12 +249,12 @@ static int rvt_query_pkey(struct ib_device *ibdev, u8 port_num, u16 index,
  *
  * Return: 0 on success
  */
-static int rvt_query_gid(struct ib_device *ibdev, u8 port_num,
+static int rvt_query_gid(struct ib_device *ibdev, u32 port_num,
 			 int guid_index, union ib_gid *gid)
 {
 	struct rvt_dev_info *rdi;
 	struct rvt_ibport *rvp;
-	int port_index;
+	u32 port_index;

 	/*
 	 * Driver is responsible for updating the guid table. Which will be used
@@ -270,8 +262,6 @@ static int rvt_query_gid(struct ib_device *ibdev, u8 port_num,
 	 * is being done.
 	 */
 	port_index = ibport_num_to_idx(ibdev, port_num);
-	if (port_index < 0)
-		return -EINVAL;

 	rdi = ib_to_rvt(ibdev);
 	rvp = rdi->ports[port_index];
@@ -301,16 +291,12 @@ static void rvt_dealloc_ucontext(struct ib_ucontext *context)
 	return;
 }

-static int rvt_get_port_immutable(struct ib_device *ibdev, u8 port_num,
+static int rvt_get_port_immutable(struct ib_device *ibdev, u32 port_num,
 				  struct ib_port_immutable *immutable)
 {
 	struct rvt_dev_info *rdi = ib_to_rvt(ibdev);
 	struct ib_port_attr attr;
-	int err, port_index;
-
-	port_index = ibport_num_to_idx(ibdev, port_num);
-	if (port_index < 0)
-		return -EINVAL;
+	int err;

 	immutable->core_cap_flags = rdi->dparms.core_cap_flags;

diff --git a/drivers/infiniband/sw/rdmavt/vt.h b/drivers/infiniband/sw/rdmavt/vt.h
index d19ff817c2c7..c0fed6510f0b 100644
--- a/drivers/infiniband/sw/rdmavt/vt.h
+++ b/drivers/infiniband/sw/rdmavt/vt.h
@@ -96,16 +96,9 @@
 #define __rvt_pr_err_ratelimited(pdev, name, fmt, ...) \
 	dev_err_ratelimited(&(pdev)->dev, "%s: " fmt, name, ##__VA_ARGS__)

-static inline int ibport_num_to_idx(struct ib_device *ibdev, u8 port_num)
+static inline u32 ibport_num_to_idx(struct ib_device *ibdev, u32 port_num)
 {
-	struct rvt_dev_info *rdi = ib_to_rvt(ibdev);
-	int port_index;
-
-	port_index = port_num - 1; /* IB ports start at 1 our arrays at 0 */
-	if ((port_index < 0) || (port_index >= rdi->dparms.nports))
-		return -EINVAL;
-
-	return port_index;
+	return port_num - 1; /* IB ports start at 1 our arrays at 0 */
 }

 #endif          /* DEF_RDMAVT_H */
diff --git a/drivers/infiniband/sw/rxe/rxe_hw_counters.c b/drivers/infiniband/sw/rxe/rxe_hw_counters.c
index ac9154f0593d..f469fd1c753d 100644
--- a/drivers/infiniband/sw/rxe/rxe_hw_counters.c
+++ b/drivers/infiniband/sw/rxe/rxe_hw_counters.c
@@ -26,7 +26,7 @@ static const char * const rxe_counter_name[] = {

 int rxe_ib_get_hw_stats(struct ib_device *ibdev,
 			struct rdma_hw_stats *stats,
-			u8 port, int index)
+			u32 port, int index)
 {
 	struct rxe_dev *dev = to_rdev(ibdev);
 	unsigned int cnt;
@@ -41,7 +41,7 @@ int rxe_ib_get_hw_stats(struct ib_device *ibdev,
 }

 struct rdma_hw_stats *rxe_ib_alloc_hw_stats(struct ib_device *ibdev,
-					    u8 port_num)
+					    u32 port_num)
 {
 	BUILD_BUG_ON(ARRAY_SIZE(rxe_counter_name) != RXE_NUM_OF_COUNTERS);
 	/* We support only per port stats */
diff --git a/drivers/infiniband/sw/rxe/rxe_hw_counters.h b/drivers/infiniband/sw/rxe/rxe_hw_counters.h
index 49ee6f96656d..2f369acb46d7 100644
--- a/drivers/infiniband/sw/rxe/rxe_hw_counters.h
+++ b/drivers/infiniband/sw/rxe/rxe_hw_counters.h
@@ -30,8 +30,8 @@ enum rxe_counters {
 };

 struct rdma_hw_stats *rxe_ib_alloc_hw_stats(struct ib_device *ibdev,
-					    u8 port_num);
+					    u32 port_num);
 int rxe_ib_get_hw_stats(struct ib_device *ibdev,
 			struct rdma_hw_stats *stats,
-			u8 port, int index);
+			u32 port, int index);
 #endif /* RXE_HW_COUNTERS_H */
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index dee5e0e919d2..a76139a92067 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -26,7 +26,7 @@ static int rxe_query_device(struct ib_device *dev,
 }

 static int rxe_query_port(struct ib_device *dev,
-			  u8 port_num, struct ib_port_attr *attr)
+			  u32 port_num, struct ib_port_attr *attr)
 {
 	struct rxe_dev *rxe = to_rdev(dev);
 	struct rxe_port *port;
@@ -54,7 +54,7 @@ static int rxe_query_port(struct ib_device *dev,
 }

 static int rxe_query_pkey(struct ib_device *device,
-			  u8 port_num, u16 index, u16 *pkey)
+			  u32 port_num, u16 index, u16 *pkey)
 {
 	if (index > 0)
 		return -EINVAL;
@@ -84,7 +84,7 @@ static int rxe_modify_device(struct ib_device *dev,
 }

 static int rxe_modify_port(struct ib_device *dev,
-			   u8 port_num, int mask, struct ib_port_modify *attr)
+			   u32 port_num, int mask, struct ib_port_modify *attr)
 {
 	struct rxe_dev *rxe = to_rdev(dev);
 	struct rxe_port *port;
@@ -101,7 +101,7 @@ static int rxe_modify_port(struct ib_device *dev,
 }

 static enum rdma_link_layer rxe_get_link_layer(struct ib_device *dev,
-					       u8 port_num)
+					       u32 port_num)
 {
 	return IB_LINK_LAYER_ETHERNET;
 }
@@ -121,7 +121,7 @@ static void rxe_dealloc_ucontext(struct ib_ucontext *ibuc)
 	rxe_drop_ref(uc);
 }

-static int rxe_port_immutable(struct ib_device *dev, u8 port_num,
+static int rxe_port_immutable(struct ib_device *dev, u32 port_num,
 			      struct ib_port_immutable *immutable)
 {
 	int err;
diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index e389d44e5591..d2313efb26db 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -160,7 +160,7 @@ int siw_query_device(struct ib_device *base_dev, struct ib_device_attr *attr,
 	return 0;
 }

-int siw_query_port(struct ib_device *base_dev, u8 port,
+int siw_query_port(struct ib_device *base_dev, u32 port,
 		   struct ib_port_attr *attr)
 {
 	struct siw_device *sdev = to_siw_dev(base_dev);
@@ -194,7 +194,7 @@ int siw_query_port(struct ib_device *base_dev, u8 port,
 	return rv;
 }

-int siw_get_port_immutable(struct ib_device *base_dev, u8 port,
+int siw_get_port_immutable(struct ib_device *base_dev, u32 port,
 			   struct ib_port_immutable *port_immutable)
 {
 	struct ib_port_attr attr;
@@ -209,7 +209,7 @@ int siw_get_port_immutable(struct ib_device *base_dev, u8 port,
 	return 0;
 }

-int siw_query_gid(struct ib_device *base_dev, u8 port, int idx,
+int siw_query_gid(struct ib_device *base_dev, u32 port, int idx,
 		  union ib_gid *gid)
 {
 	struct siw_device *sdev = to_siw_dev(base_dev);
@@ -1848,7 +1848,7 @@ void siw_srq_event(struct siw_srq *srq, enum ib_event_type etype)
 	}
 }

-void siw_port_event(struct siw_device *sdev, u8 port, enum ib_event_type etype)
+void siw_port_event(struct siw_device *sdev, u32 port, enum ib_event_type etype)
 {
 	struct ib_event event;

diff --git a/drivers/infiniband/sw/siw/siw_verbs.h b/drivers/infiniband/sw/siw/siw_verbs.h
index 637454529357..67ac08886a70 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.h
+++ b/drivers/infiniband/sw/siw/siw_verbs.h
@@ -36,17 +36,17 @@ static inline void siw_copy_sgl(struct ib_sge *sge, struct siw_sge *siw_sge,

 int siw_alloc_ucontext(struct ib_ucontext *base_ctx, struct ib_udata *udata);
 void siw_dealloc_ucontext(struct ib_ucontext *base_ctx);
-int siw_query_port(struct ib_device *base_dev, u8 port,
+int siw_query_port(struct ib_device *base_dev, u32 port,
 		   struct ib_port_attr *attr);
-int siw_get_port_immutable(struct ib_device *base_dev, u8 port,
+int siw_get_port_immutable(struct ib_device *base_dev, u32 port,
 			   struct ib_port_immutable *port_immutable);
 int siw_query_device(struct ib_device *base_dev, struct ib_device_attr *attr,
 		     struct ib_udata *udata);
 int siw_create_cq(struct ib_cq *base_cq, const struct ib_cq_init_attr *attr,
 		  struct ib_udata *udata);
-int siw_query_port(struct ib_device *base_dev, u8 port,
+int siw_query_port(struct ib_device *base_dev, u32 port,
 		   struct ib_port_attr *attr);
-int siw_query_gid(struct ib_device *base_dev, u8 port, int idx,
+int siw_query_gid(struct ib_device *base_dev, u32 port, int idx,
 		  union ib_gid *gid);
 int siw_alloc_pd(struct ib_pd *base_pd, struct ib_udata *udata);
 int siw_dealloc_pd(struct ib_pd *base_pd, struct ib_udata *udata);
@@ -86,6 +86,6 @@ void siw_mmap_free(struct rdma_user_mmap_entry *rdma_entry);
 void siw_qp_event(struct siw_qp *qp, enum ib_event_type type);
 void siw_cq_event(struct siw_cq *cq, enum ib_event_type type);
 void siw_srq_event(struct siw_srq *srq, enum ib_event_type type);
-void siw_port_event(struct siw_device *dev, u8 port, enum ib_event_type type);
+void siw_port_event(struct siw_device *dev, u32 port, enum ib_event_type type);

 #endif
diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 179ff1d068e5..a45f21e01269 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -501,9 +501,9 @@ void ipoib_reap_ah(struct work_struct *work);
 struct ipoib_path *__path_find(struct net_device *dev, void *gid);
 void ipoib_mark_paths_invalid(struct net_device *dev);
 void ipoib_flush_paths(struct net_device *dev);
-struct net_device *ipoib_intf_alloc(struct ib_device *hca, u8 port,
+struct net_device *ipoib_intf_alloc(struct ib_device *hca, u32 port,
 				    const char *format);
-int ipoib_intf_init(struct ib_device *hca, u8 port, const char *format,
+int ipoib_intf_init(struct ib_device *hca, u32 port, const char *format,
 		    struct net_device *dev);
 void ipoib_ib_tx_timer_func(struct timer_list *t);
 void ipoib_ib_dev_flush_light(struct work_struct *work);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 494f413dc3c6..ceabfb0b0a83 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -1060,7 +1060,7 @@ static bool ipoib_dev_addr_changed_valid(struct ipoib_dev_priv *priv)
 	union ib_gid *netdev_gid;
 	int err;
 	u16 index;
-	u8 port;
+	u32 port;
 	bool ret = false;

 	netdev_gid = (union ib_gid *)(priv->dev->dev_addr + 4);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index e16b40c09f82..8f769ebaacc6 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -90,7 +90,7 @@ static int ipoib_add_one(struct ib_device *device);
 static void ipoib_remove_one(struct ib_device *device, void *client_data);
 static void ipoib_neigh_reclaim(struct rcu_head *rp);
 static struct net_device *ipoib_get_net_dev_by_params(
-		struct ib_device *dev, u8 port, u16 pkey,
+		struct ib_device *dev, u32 port, u16 pkey,
 		const union ib_gid *gid, const struct sockaddr *addr,
 		void *client_data);
 static int ipoib_set_mac(struct net_device *dev, void *addr);
@@ -438,7 +438,7 @@ static int ipoib_match_gid_pkey_addr(struct ipoib_dev_priv *priv,
 /* Returns the number of matching net_devs found (between 0 and 2). Also
  * return the matching net_device in the @net_dev parameter, holding a
  * reference to the net_device, if the number of matches >= 1 */
-static int __ipoib_get_net_dev_by_params(struct list_head *dev_list, u8 port,
+static int __ipoib_get_net_dev_by_params(struct list_head *dev_list, u32 port,
 					 u16 pkey_index,
 					 const union ib_gid *gid,
 					 const struct sockaddr *addr,
@@ -463,7 +463,7 @@ static int __ipoib_get_net_dev_by_params(struct list_head *dev_list, u8 port,
 }

 static struct net_device *ipoib_get_net_dev_by_params(
-		struct ib_device *dev, u8 port, u16 pkey,
+		struct ib_device *dev, u32 port, u16 pkey,
 		const union ib_gid *gid, const struct sockaddr *addr,
 		void *client_data)
 {
@@ -2145,7 +2145,7 @@ static void ipoib_build_priv(struct net_device *dev)
 	INIT_DELAYED_WORK(&priv->neigh_reap_task, ipoib_reap_neigh);
 }

-static struct net_device *ipoib_alloc_netdev(struct ib_device *hca, u8 port,
+static struct net_device *ipoib_alloc_netdev(struct ib_device *hca, u32 port,
 					     const char *name)
 {
 	struct net_device *dev;
@@ -2162,7 +2162,7 @@ static struct net_device *ipoib_alloc_netdev(struct ib_device *hca, u8 port,
 	return dev;
 }

-int ipoib_intf_init(struct ib_device *hca, u8 port, const char *name,
+int ipoib_intf_init(struct ib_device *hca, u32 port, const char *name,
 		    struct net_device *dev)
 {
 	struct rdma_netdev *rn = netdev_priv(dev);
@@ -2213,7 +2213,7 @@ int ipoib_intf_init(struct ib_device *hca, u8 port, const char *name,
 	return rc;
 }

-struct net_device *ipoib_intf_alloc(struct ib_device *hca, u8 port,
+struct net_device *ipoib_intf_alloc(struct ib_device *hca, u32 port,
 				    const char *name)
 {
 	struct net_device *dev;
@@ -2456,7 +2456,7 @@ static int ipoib_intercept_dev_id_attr(struct net_device *dev)
 }

 static struct net_device *ipoib_add_port(const char *format,
-					 struct ib_device *hca, u8 port)
+					 struct ib_device *hca, u32 port)
 {
 	struct rtnl_link_ops *ops = ipoib_get_link_ops();
 	struct rdma_netdev_alloc_params params;
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 6be60aa5ffe2..5b8849c6d79a 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3105,7 +3105,8 @@ static int srpt_add_one(struct ib_device *device)
 {
 	struct srpt_device *sdev;
 	struct srpt_port *sport;
-	int i, ret;
+	int ret;
+	u32 i;

 	pr_debug("device = %p\n", device);

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 1eeca45cfcdf..2585c68f6d3c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -718,7 +718,7 @@ static const struct mlx5e_profile *mlx5_get_profile(struct mlx5_core_dev *mdev)
 	return &mlx5i_nic_profile;
 }

-static int mlx5_rdma_setup_rn(struct ib_device *ibdev, u8 port_num,
+static int mlx5_rdma_setup_rn(struct ib_device *ibdev, u32 port_num,
 			      struct net_device *netdev, void *param)
 {
 	struct mlx5_core_dev *mdev = (struct mlx5_core_dev *)param;
diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index bae29f50adff..226ae3702d8a 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -10,7 +10,7 @@

 #include <rdma/ib_verbs.h>

-int rdma_query_gid(struct ib_device *device, u8 port_num, int index,
+int rdma_query_gid(struct ib_device *device, u32 port_num, int index,
 		   union ib_gid *gid);
 void *rdma_read_gid_hw_context(const struct ib_gid_attr *attr);
 const struct ib_gid_attr *rdma_find_gid(struct ib_device *device,
@@ -20,10 +20,10 @@ const struct ib_gid_attr *rdma_find_gid(struct ib_device *device,
 const struct ib_gid_attr *rdma_find_gid_by_port(struct ib_device *ib_dev,
 						const union ib_gid *gid,
 						enum ib_gid_type gid_type,
-						u8 port,
+						u32 port,
 						struct net_device *ndev);
 const struct ib_gid_attr *rdma_find_gid_by_filter(
-	struct ib_device *device, const union ib_gid *gid, u8 port_num,
+	struct ib_device *device, const union ib_gid *gid, u32 port_num,
 	bool (*filter)(const union ib_gid *gid, const struct ib_gid_attr *,
 		       void *),
 	void *context);
@@ -43,7 +43,7 @@ struct net_device *rdma_read_gid_attr_ndev_rcu(const struct ib_gid_attr *attr);
  * the local software cache.
  */
 int ib_get_cached_pkey(struct ib_device    *device_handle,
-		       u8                   port_num,
+		       u32                  port_num,
 		       int                  index,
 		       u16                 *pkey);

@@ -59,7 +59,7 @@ int ib_get_cached_pkey(struct ib_device    *device_handle,
  * the local software cache.
  */
 int ib_find_cached_pkey(struct ib_device    *device,
-			u8                   port_num,
+			u32                  port_num,
 			u16                  pkey,
 			u16                 *index);

@@ -75,7 +75,7 @@ int ib_find_cached_pkey(struct ib_device    *device,
  * the local software cache.
  */
 int ib_find_exact_cached_pkey(struct ib_device    *device,
-			      u8                   port_num,
+			      u32                  port_num,
 			      u16                  pkey,
 			      u16                 *index);

@@ -89,7 +89,7 @@ int ib_find_exact_cached_pkey(struct ib_device    *device,
  * the local software cache.
  */
 int ib_get_cached_lmc(struct ib_device *device,
-		      u8                port_num,
+		      u32               port_num,
 		      u8                *lmc);

 /**
@@ -102,12 +102,12 @@ int ib_get_cached_lmc(struct ib_device *device,
  * the local software cache.
  */
 int ib_get_cached_port_state(struct ib_device *device,
-			      u8                port_num,
+			     u32               port_num,
 			      enum ib_port_state *port_active);

 bool rdma_is_zero_gid(const union ib_gid *gid);
 const struct ib_gid_attr *rdma_get_gid_attr(struct ib_device *device,
-					    u8 port_num, int index);
+					    u32 port_num, int index);
 void rdma_put_gid_attr(const struct ib_gid_attr *attr);
 void rdma_hold_gid_attr(const struct ib_gid_attr *attr);
 ssize_t rdma_query_gid_table(struct ib_device *device,
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index 8dfb1ddf345a..f1d34f06a68b 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -668,7 +668,7 @@ struct ib_mad_reg_req {
  * @registration_flags: Registration flags to set for this agent
  */
 struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
-					   u8 port_num,
+					   u32 port_num,
 					   enum ib_qp_type qp_type,
 					   struct ib_mad_reg_req *mad_reg_req,
 					   u8 rmpp_version,
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index 4c52c2fd22a1..ba3c808a3789 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -423,7 +423,7 @@ struct ib_sa_query;
 void ib_sa_cancel_query(int id, struct ib_sa_query *query);

 int ib_sa_path_rec_get(struct ib_sa_client *client, struct ib_device *device,
-		       u8 port_num, struct sa_path_rec *rec,
+		       u32 port_num, struct sa_path_rec *rec,
 		       ib_sa_comp_mask comp_mask, unsigned long timeout_ms,
 		       gfp_t gfp_mask,
 		       void (*callback)(int status, struct sa_path_rec *resp,
@@ -431,7 +431,7 @@ int ib_sa_path_rec_get(struct ib_sa_client *client, struct ib_device *device,
 		       void *context, struct ib_sa_query **query);

 int ib_sa_service_rec_query(struct ib_sa_client *client,
-			    struct ib_device *device, u8 port_num, u8 method,
+			    struct ib_device *device, u32 port_num, u8 method,
 			    struct ib_sa_service_rec *rec,
 			    ib_sa_comp_mask comp_mask, unsigned long timeout_ms,
 			    gfp_t gfp_mask,
@@ -477,7 +477,8 @@ struct ib_sa_multicast {
  *   group, and the user must rejoin the group to continue using it.
  */
 struct ib_sa_multicast *ib_sa_join_multicast(struct ib_sa_client *client,
-					     struct ib_device *device, u8 port_num,
+					     struct ib_device *device,
+					     u32 port_num,
 					     struct ib_sa_mcmember_rec *rec,
 					     ib_sa_comp_mask comp_mask, gfp_t gfp_mask,
 					     int (*callback)(int status,
@@ -506,20 +507,20 @@ void ib_sa_free_multicast(struct ib_sa_multicast *multicast);
  * @mgid: MGID of multicast group.
  * @rec: Location to copy SA multicast member record.
  */
-int ib_sa_get_mcmember_rec(struct ib_device *device, u8 port_num,
+int ib_sa_get_mcmember_rec(struct ib_device *device, u32 port_num,
 			   union ib_gid *mgid, struct ib_sa_mcmember_rec *rec);

 /**
  * ib_init_ah_from_mcmember - Initialize address handle attributes based on
  * an SA multicast member record.
  */
-int ib_init_ah_from_mcmember(struct ib_device *device, u8 port_num,
+int ib_init_ah_from_mcmember(struct ib_device *device, u32 port_num,
 			     struct ib_sa_mcmember_rec *rec,
 			     struct net_device *ndev,
 			     enum ib_gid_type gid_type,
 			     struct rdma_ah_attr *ah_attr);

-int ib_init_ah_attr_from_path(struct ib_device *device, u8 port_num,
+int ib_init_ah_attr_from_path(struct ib_device *device, u32 port_num,
 			      struct sa_path_rec *rec,
 			      struct rdma_ah_attr *ah_attr,
 			      const struct ib_gid_attr *sgid_attr);
@@ -538,7 +539,7 @@ void ib_sa_unpack_path(void *attribute, struct sa_path_rec *rec);

 /* Support GuidInfoRecord */
 int ib_sa_guid_info_rec_query(struct ib_sa_client *client,
-			      struct ib_device *device, u8 port_num,
+			      struct ib_device *device, u32 port_num,
 			      struct ib_sa_guidinfo_rec *rec,
 			      ib_sa_comp_mask comp_mask, u8 method,
 			      unsigned long timeout_ms, gfp_t gfp_mask,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ca28fca5736b..dd02542b7350 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -152,7 +152,7 @@ struct ib_gid_attr {
 	union ib_gid		gid;
 	enum ib_gid_type	gid_type;
 	u16			index;
-	u8			port_num;
+	u32			port_num;
 };

 enum {
@@ -736,7 +736,7 @@ struct ib_event {
 		struct ib_qp	*qp;
 		struct ib_srq	*srq;
 		struct ib_wq	*wq;
-		u8		port_num;
+		u32		port_num;
 	} element;
 	enum ib_event_type	event;
 };
@@ -919,7 +919,7 @@ struct rdma_ah_attr {
 	struct ib_global_route	grh;
 	u8			sl;
 	u8			static_rate;
-	u8			port_num;
+	u32			port_num;
 	u8			ah_flags;
 	enum rdma_ah_attr_type type;
 	union {
@@ -1006,7 +1006,7 @@ struct ib_wc {
 	u16			pkey_index;
 	u8			sl;
 	u8			dlid_path_bits;
-	u8			port_num;	/* valid only for DR SMPs on switches */
+	u32 port_num; /* valid only for DR SMPs on switches */
 	u8			smac[ETH_ALEN];
 	u16			vlan_id;
 	u8			network_hdr_type;
@@ -1161,7 +1161,7 @@ struct ib_qp_init_attr {
 	/*
 	 * Only needed for special QP types, or when using the RW API.
 	 */
-	u8			port_num;
+	u32			port_num;
 	struct ib_rwq_ind_table *rwq_ind_tbl;
 	u32			source_qpn;
 };
@@ -1280,11 +1280,11 @@ struct ib_qp_attr {
 	u8			max_rd_atomic;
 	u8			max_dest_rd_atomic;
 	u8			min_rnr_timer;
-	u8			port_num;
+	u32			port_num;
 	u8			timeout;
 	u8			retry_cnt;
 	u8			rnr_retry;
-	u8			alt_port_num;
+	u32			alt_port_num;
 	u8			alt_timeout;
 	u32			rate_limit;
 	struct net_device	*xmit_slave;
@@ -1401,7 +1401,7 @@ struct ib_ud_wr {
 	u32			remote_qpn;
 	u32			remote_qkey;
 	u16			pkey_index; /* valid for GSI only */
-	u8			port_num;   /* valid for DR SMPs on switch only */
+	u32			port_num; /* valid for DR SMPs on switch only */
 };

 static inline const struct ib_ud_wr *ud_wr(const struct ib_send_wr *wr)
@@ -1708,7 +1708,7 @@ struct ib_qp_security;
 struct ib_port_pkey {
 	enum port_pkey_state	state;
 	u16			pkey_index;
-	u8			port_num;
+	u32			port_num;
 	struct list_head	qp_list;
 	struct list_head	to_error_list;
 	struct ib_qp_security  *sec;
@@ -1769,7 +1769,7 @@ struct ib_qp {
 	enum ib_qp_type		qp_type;
 	struct ib_rwq_ind_table *rwq_ind_tbl;
 	struct ib_qp_security  *qp_sec;
-	u8			port;
+	u32			port;

 	bool			integrity_en;
 	/*
@@ -2065,7 +2065,7 @@ struct ib_flow_attr {
 	u16	     priority;
 	u32	     flags;
 	u8	     num_of_specs;
-	u8	     port;
+	u32	     port;
 	union ib_flow_spec flows[];
 };

@@ -2194,7 +2194,7 @@ enum rdma_netdev_t {
 struct rdma_netdev {
 	void              *clnt_priv;
 	struct ib_device  *hca;
-	u8                 port_num;
+	u32		   port_num;
 	int                mtu;

 	/*
@@ -2223,7 +2223,7 @@ struct rdma_netdev_alloc_params {
 	unsigned int rxqs;
 	void *param;

-	int (*initialize_rdma_netdev)(struct ib_device *device, u8 port_num,
+	int (*initialize_rdma_netdev)(struct ib_device *device, u32 port_num,
 				      struct net_device *netdev, void *param);
 };

@@ -2306,7 +2306,7 @@ struct ib_device_ops {
 			     const struct ib_recv_wr *recv_wr,
 			     const struct ib_recv_wr **bad_recv_wr);
 	int (*process_mad)(struct ib_device *device, int process_mad_flags,
-			   u8 port_num, const struct ib_wc *in_wc,
+			   u32 port_num, const struct ib_wc *in_wc,
 			   const struct ib_grh *in_grh,
 			   const struct ib_mad *in_mad, struct ib_mad *out_mad,
 			   size_t *out_mad_size, u16 *out_mad_pkey_index);
@@ -2318,9 +2318,9 @@ struct ib_device_ops {
 	void (*get_dev_fw_str)(struct ib_device *device, char *str);
 	const struct cpumask *(*get_vector_affinity)(struct ib_device *ibdev,
 						     int comp_vector);
-	int (*query_port)(struct ib_device *device, u8 port_num,
+	int (*query_port)(struct ib_device *device, u32 port_num,
 			  struct ib_port_attr *port_attr);
-	int (*modify_port)(struct ib_device *device, u8 port_num,
+	int (*modify_port)(struct ib_device *device, u32 port_num,
 			   int port_modify_mask,
 			   struct ib_port_modify *port_modify);
 	/**
@@ -2329,10 +2329,10 @@ struct ib_device_ops {
 	 * structure to avoid cache line misses when accessing struct ib_device
 	 * in fast paths.
 	 */
-	int (*get_port_immutable)(struct ib_device *device, u8 port_num,
+	int (*get_port_immutable)(struct ib_device *device, u32 port_num,
 				  struct ib_port_immutable *immutable);
 	enum rdma_link_layer (*get_link_layer)(struct ib_device *device,
-					       u8 port_num);
+					       u32 port_num);
 	/**
 	 * When calling get_netdev, the HW vendor's driver should return the
 	 * net device of device @device at port @port_num or NULL if such
@@ -2341,7 +2341,8 @@ struct ib_device_ops {
 	 * that this function returns NULL before the net device has finished
 	 * NETDEV_UNREGISTER state.
 	 */
-	struct net_device *(*get_netdev)(struct ib_device *device, u8 port_num);
+	struct net_device *(*get_netdev)(struct ib_device *device,
+					 u32 port_num);
 	/**
 	 * rdma netdev operation
 	 *
@@ -2349,11 +2350,11 @@ struct ib_device_ops {
 	 * must return -EOPNOTSUPP if it doesn't support the specified type.
 	 */
 	struct net_device *(*alloc_rdma_netdev)(
-		struct ib_device *device, u8 port_num, enum rdma_netdev_t type,
+		struct ib_device *device, u32 port_num, enum rdma_netdev_t type,
 		const char *name, unsigned char name_assign_type,
 		void (*setup)(struct net_device *));

-	int (*rdma_netdev_get_params)(struct ib_device *device, u8 port_num,
+	int (*rdma_netdev_get_params)(struct ib_device *device, u32 port_num,
 				      enum rdma_netdev_t type,
 				      struct rdma_netdev_alloc_params *params);
 	/**
@@ -2361,7 +2362,7 @@ struct ib_device_ops {
 	 * link layer is either IB or iWarp. It is no-op if @port_num port
 	 * is RoCE link layer.
 	 */
-	int (*query_gid)(struct ib_device *device, u8 port_num, int index,
+	int (*query_gid)(struct ib_device *device, u32 port_num, int index,
 			 union ib_gid *gid);
 	/**
 	 * When calling add_gid, the HW vendor's driver should add the gid
@@ -2386,7 +2387,7 @@ struct ib_device_ops {
 	 * This function is only called when roce_gid_table is used.
 	 */
 	int (*del_gid)(const struct ib_gid_attr *attr, void **context);
-	int (*query_pkey)(struct ib_device *device, u8 port_num, u16 index,
+	int (*query_pkey)(struct ib_device *device, u32 port_num, u16 index,
 			  u16 *pkey);
 	int (*alloc_ucontext)(struct ib_ucontext *context,
 			      struct ib_udata *udata);
@@ -2475,16 +2476,16 @@ struct ib_device_ops {
 		struct ib_flow_action *action,
 		const struct ib_flow_action_attrs_esp *attr,
 		struct uverbs_attr_bundle *attrs);
-	int (*set_vf_link_state)(struct ib_device *device, int vf, u8 port,
+	int (*set_vf_link_state)(struct ib_device *device, int vf, u32 port,
 				 int state);
-	int (*get_vf_config)(struct ib_device *device, int vf, u8 port,
+	int (*get_vf_config)(struct ib_device *device, int vf, u32 port,
 			     struct ifla_vf_info *ivf);
-	int (*get_vf_stats)(struct ib_device *device, int vf, u8 port,
+	int (*get_vf_stats)(struct ib_device *device, int vf, u32 port,
 			    struct ifla_vf_stats *stats);
-	int (*get_vf_guid)(struct ib_device *device, int vf, u8 port,
+	int (*get_vf_guid)(struct ib_device *device, int vf, u32 port,
 			    struct ifla_vf_guid *node_guid,
 			    struct ifla_vf_guid *port_guid);
-	int (*set_vf_guid)(struct ib_device *device, int vf, u8 port, u64 guid,
+	int (*set_vf_guid)(struct ib_device *device, int vf, u32 port, u64 guid,
 			   int type);
 	struct ib_wq *(*create_wq)(struct ib_pd *pd,
 				   struct ib_wq_init_attr *init_attr,
@@ -2522,7 +2523,7 @@ struct ib_device_ops {
 	 *   struct tells the core to set a default lifespan.
 	 */
 	struct rdma_hw_stats *(*alloc_hw_stats)(struct ib_device *device,
-						u8 port_num);
+						u32 port_num);
 	/**
 	 * get_hw_stats - Fill in the counter value(s) in the stats struct.
 	 * @index - The index in the value array we wish to have updated, or
@@ -2536,12 +2537,12 @@ struct ib_device_ops {
 	 *   one given in index at their option
 	 */
 	int (*get_hw_stats)(struct ib_device *device,
-			    struct rdma_hw_stats *stats, u8 port, int index);
+			    struct rdma_hw_stats *stats, u32 port, int index);
 	/*
 	 * This function is called once for each port when a ib device is
 	 * registered.
 	 */
-	int (*init_port)(struct ib_device *device, u8 port_num,
+	int (*init_port)(struct ib_device *device, u32 port_num,
 			 struct kobject *port_sysfs);
 	/**
 	 * Allows rdma drivers to add their own restrack attributes.
@@ -2685,7 +2686,7 @@ struct ib_device {
 	/* CQ adaptive moderation (RDMA DIM) */
 	u16                          use_cq_dim:1;
 	u8                           node_type;
-	u8                           phys_port_cnt;
+	u32			     phys_port_cnt;
 	struct ib_device_attr        attrs;
 	struct attribute_group	     *hw_stats_ag;
 	struct rdma_hw_stats         *hw_stats;
@@ -2751,7 +2752,7 @@ struct ib_client {
 	 * netdev. */
 	struct net_device *(*get_net_dev_by_params)(
 			struct ib_device *dev,
-			u8 port,
+			u32 port,
 			u16 pkey,
 			const union ib_gid *gid,
 			const struct sockaddr *addr,
@@ -2932,10 +2933,10 @@ void ib_unregister_event_handler(struct ib_event_handler *event_handler);
 void ib_dispatch_event(const struct ib_event *event);

 int ib_query_port(struct ib_device *device,
-		  u8 port_num, struct ib_port_attr *port_attr);
+		  u32 port_num, struct ib_port_attr *port_attr);

 enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *device,
-					       u8 port_num);
+					       u32 port_num);

 /**
  * rdma_cap_ib_switch - Check if the device is IB switch
@@ -2959,7 +2960,7 @@ static inline bool rdma_cap_ib_switch(const struct ib_device *device)
  *
  * Return start port number
  */
-static inline u8 rdma_start_port(const struct ib_device *device)
+static inline u32 rdma_start_port(const struct ib_device *device)
 {
 	return rdma_cap_ib_switch(device) ? 0 : 1;
 }
@@ -2970,9 +2971,10 @@ static inline u8 rdma_start_port(const struct ib_device *device)
  * @iter - The unsigned int to store the port number
  */
 #define rdma_for_each_port(device, iter)                                       \
-	for (iter = rdma_start_port(device + BUILD_BUG_ON_ZERO(!__same_type(   \
-						     unsigned int, iter)));    \
-	     iter <= rdma_end_port(device); (iter)++)
+	for (iter = rdma_start_port(device +				       \
+				    BUILD_BUG_ON_ZERO(!__same_type(u32,	       \
+								   iter)));    \
+	     iter <= rdma_end_port(device); iter++)

 /**
  * rdma_end_port - Return the last valid port number for the device
@@ -2982,7 +2984,7 @@ static inline u8 rdma_start_port(const struct ib_device *device)
  *
  * Return last port number
  */
-static inline u8 rdma_end_port(const struct ib_device *device)
+static inline u32 rdma_end_port(const struct ib_device *device)
 {
 	return rdma_cap_ib_switch(device) ? 0 : device->phys_port_cnt;
 }
@@ -2995,55 +2997,63 @@ static inline int rdma_is_port_valid(const struct ib_device *device,
 }

 static inline bool rdma_is_grh_required(const struct ib_device *device,
-					u8 port_num)
+					u32 port_num)
 {
 	return device->port_data[port_num].immutable.core_cap_flags &
 	       RDMA_CORE_PORT_IB_GRH_REQUIRED;
 }

-static inline bool rdma_protocol_ib(const struct ib_device *device, u8 port_num)
+static inline bool rdma_protocol_ib(const struct ib_device *device,
+				    u32 port_num)
 {
 	return device->port_data[port_num].immutable.core_cap_flags &
 	       RDMA_CORE_CAP_PROT_IB;
 }

-static inline bool rdma_protocol_roce(const struct ib_device *device, u8 port_num)
+static inline bool rdma_protocol_roce(const struct ib_device *device,
+				      u32 port_num)
 {
 	return device->port_data[port_num].immutable.core_cap_flags &
 	       (RDMA_CORE_CAP_PROT_ROCE | RDMA_CORE_CAP_PROT_ROCE_UDP_ENCAP);
 }

-static inline bool rdma_protocol_roce_udp_encap(const struct ib_device *device, u8 port_num)
+static inline bool rdma_protocol_roce_udp_encap(const struct ib_device *device,
+						u32 port_num)
 {
 	return device->port_data[port_num].immutable.core_cap_flags &
 	       RDMA_CORE_CAP_PROT_ROCE_UDP_ENCAP;
 }

-static inline bool rdma_protocol_roce_eth_encap(const struct ib_device *device, u8 port_num)
+static inline bool rdma_protocol_roce_eth_encap(const struct ib_device *device,
+						u32 port_num)
 {
 	return device->port_data[port_num].immutable.core_cap_flags &
 	       RDMA_CORE_CAP_PROT_ROCE;
 }

-static inline bool rdma_protocol_iwarp(const struct ib_device *device, u8 port_num)
+static inline bool rdma_protocol_iwarp(const struct ib_device *device,
+				       u32 port_num)
 {
 	return device->port_data[port_num].immutable.core_cap_flags &
 	       RDMA_CORE_CAP_PROT_IWARP;
 }

-static inline bool rdma_ib_or_roce(const struct ib_device *device, u8 port_num)
+static inline bool rdma_ib_or_roce(const struct ib_device *device,
+				   u32 port_num)
 {
 	return rdma_protocol_ib(device, port_num) ||
 		rdma_protocol_roce(device, port_num);
 }

-static inline bool rdma_protocol_raw_packet(const struct ib_device *device, u8 port_num)
+static inline bool rdma_protocol_raw_packet(const struct ib_device *device,
+					    u32 port_num)
 {
 	return device->port_data[port_num].immutable.core_cap_flags &
 	       RDMA_CORE_CAP_PROT_RAW_PACKET;
 }

-static inline bool rdma_protocol_usnic(const struct ib_device *device, u8 port_num)
+static inline bool rdma_protocol_usnic(const struct ib_device *device,
+				       u32 port_num)
 {
 	return device->port_data[port_num].immutable.core_cap_flags &
 	       RDMA_CORE_CAP_PROT_USNIC;
@@ -3061,7 +3071,7 @@ static inline bool rdma_protocol_usnic(const struct ib_device *device, u8 port_n
  *
  * Return: true if the port supports sending/receiving of MAD packets.
  */
-static inline bool rdma_cap_ib_mad(const struct ib_device *device, u8 port_num)
+static inline bool rdma_cap_ib_mad(const struct ib_device *device, u32 port_num)
 {
 	return device->port_data[port_num].immutable.core_cap_flags &
 	       RDMA_CORE_CAP_IB_MAD;
@@ -3086,7 +3096,7 @@ static inline bool rdma_cap_ib_mad(const struct ib_device *device, u8 port_num)
  *
  * Return: true if the port supports OPA MAD packet formats.
  */
-static inline bool rdma_cap_opa_mad(struct ib_device *device, u8 port_num)
+static inline bool rdma_cap_opa_mad(struct ib_device *device, u32 port_num)
 {
 	return device->port_data[port_num].immutable.core_cap_flags &
 		RDMA_CORE_CAP_OPA_MAD;
@@ -3112,7 +3122,7 @@ static inline bool rdma_cap_opa_mad(struct ib_device *device, u8 port_num)
  *
  * Return: true if the port provides an SMI.
  */
-static inline bool rdma_cap_ib_smi(const struct ib_device *device, u8 port_num)
+static inline bool rdma_cap_ib_smi(const struct ib_device *device, u32 port_num)
 {
 	return device->port_data[port_num].immutable.core_cap_flags &
 	       RDMA_CORE_CAP_IB_SMI;
@@ -3133,7 +3143,7 @@ static inline bool rdma_cap_ib_smi(const struct ib_device *device, u8 port_num)
  * Return: true if the port supports an IB CM (this does not guarantee that
  * a CM is actually running however).
  */
-static inline bool rdma_cap_ib_cm(const struct ib_device *device, u8 port_num)
+static inline bool rdma_cap_ib_cm(const struct ib_device *device, u32 port_num)
 {
 	return device->port_data[port_num].immutable.core_cap_flags &
 	       RDMA_CORE_CAP_IB_CM;
@@ -3151,7 +3161,7 @@ static inline bool rdma_cap_ib_cm(const struct ib_device *device, u8 port_num)
  * Return: true if the port supports an iWARP CM (this does not guarantee that
  * a CM is actually running however).
  */
-static inline bool rdma_cap_iw_cm(const struct ib_device *device, u8 port_num)
+static inline bool rdma_cap_iw_cm(const struct ib_device *device, u32 port_num)
 {
 	return device->port_data[port_num].immutable.core_cap_flags &
 	       RDMA_CORE_CAP_IW_CM;
@@ -3172,7 +3182,7 @@ static inline bool rdma_cap_iw_cm(const struct ib_device *device, u8 port_num)
  * Administration interface.  This does not imply that the SA service is
  * running locally.
  */
-static inline bool rdma_cap_ib_sa(const struct ib_device *device, u8 port_num)
+static inline bool rdma_cap_ib_sa(const struct ib_device *device, u32 port_num)
 {
 	return device->port_data[port_num].immutable.core_cap_flags &
 	       RDMA_CORE_CAP_IB_SA;
@@ -3195,7 +3205,8 @@ static inline bool rdma_cap_ib_sa(const struct ib_device *device, u8 port_num)
  * overhead of registering/unregistering with the SM and tracking of the
  * total number of queue pairs attached to the multicast group.
  */
-static inline bool rdma_cap_ib_mcast(const struct ib_device *device, u8 port_num)
+static inline bool rdma_cap_ib_mcast(const struct ib_device *device,
+				     u32 port_num)
 {
 	return rdma_cap_ib_sa(device, port_num);
 }
@@ -3213,7 +3224,7 @@ static inline bool rdma_cap_ib_mcast(const struct ib_device *device, u8 port_num
  * Return: true if the port uses a GID address to identify devices on the
  * network.
  */
-static inline bool rdma_cap_af_ib(const struct ib_device *device, u8 port_num)
+static inline bool rdma_cap_af_ib(const struct ib_device *device, u32 port_num)
 {
 	return device->port_data[port_num].immutable.core_cap_flags &
 	       RDMA_CORE_CAP_AF_IB;
@@ -3235,7 +3246,7 @@ static inline bool rdma_cap_af_ib(const struct ib_device *device, u8 port_num)
  * addition of a Global Route Header built from our Ethernet Address
  * Handle into our header list for connectionless packets.
  */
-static inline bool rdma_cap_eth_ah(const struct ib_device *device, u8 port_num)
+static inline bool rdma_cap_eth_ah(const struct ib_device *device, u32 port_num)
 {
 	return device->port_data[port_num].immutable.core_cap_flags &
 	       RDMA_CORE_CAP_ETH_AH;
@@ -3250,7 +3261,7 @@ static inline bool rdma_cap_eth_ah(const struct ib_device *device, u8 port_num)
  * Return: true if we are running on an OPA device which supports
  * the extended OPA addressing.
  */
-static inline bool rdma_cap_opa_ah(struct ib_device *device, u8 port_num)
+static inline bool rdma_cap_opa_ah(struct ib_device *device, u32 port_num)
 {
 	return (device->port_data[port_num].immutable.core_cap_flags &
 		RDMA_CORE_CAP_OPA_AH) == RDMA_CORE_CAP_OPA_AH;
@@ -3268,7 +3279,8 @@ static inline bool rdma_cap_opa_ah(struct ib_device *device, u8 port_num)
  * Return the max MAD size required by the Port.  Will return 0 if the port
  * does not support MADs
  */
-static inline size_t rdma_max_mad_size(const struct ib_device *device, u8 port_num)
+static inline size_t rdma_max_mad_size(const struct ib_device *device,
+				       u32 port_num)
 {
 	return device->port_data[port_num].immutable.max_mad_size;
 }
@@ -3287,7 +3299,7 @@ static inline size_t rdma_max_mad_size(const struct ib_device *device, u8 port_n
  * its GIDs.
  */
 static inline bool rdma_cap_roce_gid_table(const struct ib_device *device,
-					   u8 port_num)
+					   u32 port_num)
 {
 	return rdma_protocol_roce(device, port_num) &&
 		device->ops.add_gid && device->ops.del_gid;
@@ -3328,7 +3340,7 @@ static inline bool rdma_core_cap_opa_port(struct ib_device *device,
  * Return the MTU size supported by the port as an integer value. Will return
  * -1 if enum value of mtu is not supported.
  */
-static inline int rdma_mtu_enum_to_int(struct ib_device *device, u8 port,
+static inline int rdma_mtu_enum_to_int(struct ib_device *device, u32 port,
 				       int mtu)
 {
 	if (rdma_core_cap_opa_port(device, port))
@@ -3345,7 +3357,7 @@ static inline int rdma_mtu_enum_to_int(struct ib_device *device, u8 port,
  *
  * Return the MTU size supported by the port as an integer value.
  */
-static inline int rdma_mtu_from_attr(struct ib_device *device, u8 port,
+static inline int rdma_mtu_from_attr(struct ib_device *device, u32 port,
 				     struct ib_port_attr *attr)
 {
 	if (rdma_core_cap_opa_port(device, port))
@@ -3354,34 +3366,34 @@ static inline int rdma_mtu_from_attr(struct ib_device *device, u8 port,
 		return ib_mtu_enum_to_int(attr->max_mtu);
 }

-int ib_set_vf_link_state(struct ib_device *device, int vf, u8 port,
+int ib_set_vf_link_state(struct ib_device *device, int vf, u32 port,
 			 int state);
-int ib_get_vf_config(struct ib_device *device, int vf, u8 port,
+int ib_get_vf_config(struct ib_device *device, int vf, u32 port,
 		     struct ifla_vf_info *info);
-int ib_get_vf_stats(struct ib_device *device, int vf, u8 port,
+int ib_get_vf_stats(struct ib_device *device, int vf, u32 port,
 		    struct ifla_vf_stats *stats);
-int ib_get_vf_guid(struct ib_device *device, int vf, u8 port,
+int ib_get_vf_guid(struct ib_device *device, int vf, u32 port,
 		    struct ifla_vf_guid *node_guid,
 		    struct ifla_vf_guid *port_guid);
-int ib_set_vf_guid(struct ib_device *device, int vf, u8 port, u64 guid,
+int ib_set_vf_guid(struct ib_device *device, int vf, u32 port, u64 guid,
 		   int type);

 int ib_query_pkey(struct ib_device *device,
-		  u8 port_num, u16 index, u16 *pkey);
+		  u32 port_num, u16 index, u16 *pkey);

 int ib_modify_device(struct ib_device *device,
 		     int device_modify_mask,
 		     struct ib_device_modify *device_modify);

 int ib_modify_port(struct ib_device *device,
-		   u8 port_num, int port_modify_mask,
+		   u32 port_num, int port_modify_mask,
 		   struct ib_port_modify *port_modify);

 int ib_find_gid(struct ib_device *device, union ib_gid *gid,
-		u8 *port_num, u16 *index);
+		u32 *port_num, u16 *index);

 int ib_find_pkey(struct ib_device *device,
-		 u8 port_num, u16 pkey, u16 *index);
+		 u32 port_num, u16 pkey, u16 *index);

 enum ib_pd_flags {
 	/*
@@ -3496,7 +3508,7 @@ int ib_get_rdma_header_version(const union rdma_network_hdr *hdr);
  * attributes which are initialized using ib_init_ah_attr_from_wc().
  *
  */
-int ib_init_ah_attr_from_wc(struct ib_device *device, u8 port_num,
+int ib_init_ah_attr_from_wc(struct ib_device *device, u32 port_num,
 			    const struct ib_wc *wc, const struct ib_grh *grh,
 			    struct rdma_ah_attr *ah_attr);

@@ -3513,7 +3525,7 @@ int ib_init_ah_attr_from_wc(struct ib_device *device, u8 port_num,
  * in all UD QP post sends.
  */
 struct ib_ah *ib_create_ah_from_wc(struct ib_pd *pd, const struct ib_wc *wc,
-				   const struct ib_grh *grh, u8 port_num);
+				   const struct ib_grh *grh, u32 port_num);

 /**
  * rdma_modify_ah - Modifies the address vector associated with an address
@@ -4272,12 +4284,12 @@ struct ib_device *ib_device_get_by_netdev(struct net_device *ndev,
 					  enum rdma_driver_id driver_id);
 struct ib_device *ib_device_get_by_name(const char *name,
 					enum rdma_driver_id driver_id);
-struct net_device *ib_get_net_dev_by_params(struct ib_device *dev, u8 port,
+struct net_device *ib_get_net_dev_by_params(struct ib_device *dev, u32 port,
 					    u16 pkey, const union ib_gid *gid,
 					    const struct sockaddr *addr);
 int ib_device_set_netdev(struct ib_device *ib_dev, struct net_device *ndev,
 			 unsigned int port);
-struct net_device *ib_device_netdev(struct ib_device *dev, u8 port);
+struct net_device *ib_device_netdev(struct ib_device *dev, u32 port);

 struct ib_wq *ib_create_wq(struct ib_pd *pd,
 			   struct ib_wq_init_attr *init_attr);
@@ -4311,7 +4323,8 @@ void ib_drain_rq(struct ib_qp *qp);
 void ib_drain_sq(struct ib_qp *qp);
 void ib_drain_qp(struct ib_qp *qp);

-int ib_get_eth_speed(struct ib_device *dev, u8 port_num, u16 *speed, u8 *width);
+int ib_get_eth_speed(struct ib_device *dev, u32 port_num, u16 *speed,
+		     u8 *width);

 static inline u8 *rdma_ah_retrieve_dmac(struct rdma_ah_attr *attr)
 {
@@ -4379,12 +4392,12 @@ static inline bool rdma_ah_get_make_grd(const struct rdma_ah_attr *attr)
 	return false;
 }

-static inline void rdma_ah_set_port_num(struct rdma_ah_attr *attr, u8 port_num)
+static inline void rdma_ah_set_port_num(struct rdma_ah_attr *attr, u32 port_num)
 {
 	attr->port_num = port_num;
 }

-static inline u8 rdma_ah_get_port_num(const struct rdma_ah_attr *attr)
+static inline u32 rdma_ah_get_port_num(const struct rdma_ah_attr *attr)
 {
 	return attr->port_num;
 }
@@ -4482,7 +4495,7 @@ void rdma_move_ah_attr(struct rdma_ah_attr *dest, struct rdma_ah_attr *src);
  * @port_num: Port number
  */
 static inline enum rdma_ah_attr_type rdma_ah_find_type(struct ib_device *dev,
-						       u8 port_num)
+						       u32 port_num)
 {
 	if (rdma_protocol_roce(dev, port_num))
 		return RDMA_AH_ATTR_TYPE_ROCE;
@@ -4554,12 +4567,12 @@ struct ib_ucontext *ib_uverbs_get_ucontext_file(struct ib_uverbs_file *ufile);

 int uverbs_destroy_def_handler(struct uverbs_attr_bundle *attrs);

-struct net_device *rdma_alloc_netdev(struct ib_device *device, u8 port_num,
+struct net_device *rdma_alloc_netdev(struct ib_device *device, u32 port_num,
 				     enum rdma_netdev_t type, const char *name,
 				     unsigned char name_assign_type,
 				     void (*setup)(struct net_device *));

-int rdma_init_netdev(struct ib_device *device, u8 port_num,
+int rdma_init_netdev(struct ib_device *device, u32 port_num,
 		     enum rdma_netdev_t type, const char *name,
 		     unsigned char name_assign_type,
 		     void (*setup)(struct net_device *),
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index 32a67af18415..b2eed6d30543 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -107,7 +107,7 @@ struct rdma_cm_id {
 	struct rdma_route	 route;
 	enum rdma_ucm_port_space ps;
 	enum ib_qp_type		 qp_type;
-	u8			 port_num;
+	u32			 port_num;
 };

 struct rdma_cm_id *
diff --git a/include/rdma/rdma_counter.h b/include/rdma/rdma_counter.h
index e75cf9742e04..0295b22cd1cd 100644
--- a/include/rdma/rdma_counter.h
+++ b/include/rdma/rdma_counter.h
@@ -40,26 +40,26 @@ struct rdma_counter {
 	struct rdma_counter_mode	mode;
 	struct mutex			lock;
 	struct rdma_hw_stats		*stats;
-	u8				port;
+	u32				port;
 };

 void rdma_counter_init(struct ib_device *dev);
 void rdma_counter_release(struct ib_device *dev);
-int rdma_counter_set_auto_mode(struct ib_device *dev, u8 port,
+int rdma_counter_set_auto_mode(struct ib_device *dev, u32 port,
 			       enum rdma_nl_counter_mask mask,
 			       struct netlink_ext_ack *extack);
-int rdma_counter_bind_qp_auto(struct ib_qp *qp, u8 port);
+int rdma_counter_bind_qp_auto(struct ib_qp *qp, u32 port);
 int rdma_counter_unbind_qp(struct ib_qp *qp, bool force);

 int rdma_counter_query_stats(struct rdma_counter *counter);
-u64 rdma_counter_get_hwstat_value(struct ib_device *dev, u8 port, u32 index);
-int rdma_counter_bind_qpn(struct ib_device *dev, u8 port,
+u64 rdma_counter_get_hwstat_value(struct ib_device *dev, u32 port, u32 index);
+int rdma_counter_bind_qpn(struct ib_device *dev, u32 port,
 			  u32 qp_num, u32 counter_id);
-int rdma_counter_bind_qpn_alloc(struct ib_device *dev, u8 port,
+int rdma_counter_bind_qpn_alloc(struct ib_device *dev, u32 port,
 				u32 qp_num, u32 *counter_id);
-int rdma_counter_unbind_qpn(struct ib_device *dev, u8 port,
+int rdma_counter_unbind_qpn(struct ib_device *dev, u32 port,
 			    u32 qp_num, u32 counter_id);
-int rdma_counter_get_mode(struct ib_device *dev, u8 port,
+int rdma_counter_get_mode(struct ib_device *dev, u32 port,
 			  enum rdma_nl_counter_mode *mode,
 			  enum rdma_nl_counter_mask *mask);

diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 9fd217b24916..1b95beced0c1 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -309,16 +309,16 @@ struct rvt_driver_provided {
 	/*
 	 * Query driver for the state of the port.
 	 */
-	int (*query_port_state)(struct rvt_dev_info *rdi, u8 port_num,
+	int (*query_port_state)(struct rvt_dev_info *rdi, u32 port_num,
 				struct ib_port_attr *props);

 	/*
 	 * Tell driver to shutdown a port
 	 */
-	int (*shut_down_port)(struct rvt_dev_info *rdi, u8 port_num);
+	int (*shut_down_port)(struct rvt_dev_info *rdi, u32 port_num);

 	/* Tell driver to send a trap for changed  port capabilities */
-	void (*cap_mask_chg)(struct rvt_dev_info *rdi, u8 port_num);
+	void (*cap_mask_chg)(struct rvt_dev_info *rdi, u32 port_num);

 	/*
 	 * The following functions can be safely ignored completely. Any use of
@@ -338,7 +338,7 @@ struct rvt_driver_provided {

 	/* Let the driver pick the next queue pair number*/
 	int (*alloc_qpn)(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
-			 enum ib_qp_type type, u8 port_num);
+			 enum ib_qp_type type, u32 port_num);

 	/* Determine if its safe or allowed to modify the qp */
 	int (*check_modify_qp)(struct rvt_qp *qp, struct ib_qp_attr *attr,
diff --git a/include/rdma/rw.h b/include/rdma/rw.h
index 6ad9dc836c10..d606cac48233 100644
--- a/include/rdma/rw.h
+++ b/include/rdma/rw.h
@@ -42,29 +42,29 @@ struct rdma_rw_ctx {
 	};
 };

-int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
+int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u32 port_num,
 		struct scatterlist *sg, u32 sg_cnt, u32 sg_offset,
 		u64 remote_addr, u32 rkey, enum dma_data_direction dir);
-void rdma_rw_ctx_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
-		struct scatterlist *sg, u32 sg_cnt,
-		enum dma_data_direction dir);
+void rdma_rw_ctx_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
+			 u32 port_num, struct scatterlist *sg, u32 sg_cnt,
+			 enum dma_data_direction dir);

 int rdma_rw_ctx_signature_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
-		u8 port_num, struct scatterlist *sg, u32 sg_cnt,
+		u32 port_num, struct scatterlist *sg, u32 sg_cnt,
 		struct scatterlist *prot_sg, u32 prot_sg_cnt,
 		struct ib_sig_attrs *sig_attrs, u64 remote_addr, u32 rkey,
 		enum dma_data_direction dir);
 void rdma_rw_ctx_destroy_signature(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
-		u8 port_num, struct scatterlist *sg, u32 sg_cnt,
+		u32 port_num, struct scatterlist *sg, u32 sg_cnt,
 		struct scatterlist *prot_sg, u32 prot_sg_cnt,
 		enum dma_data_direction dir);

 struct ib_send_wr *rdma_rw_ctx_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
-		u8 port_num, struct ib_cqe *cqe, struct ib_send_wr *chain_wr);
-int rdma_rw_ctx_post(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
+		u32 port_num, struct ib_cqe *cqe, struct ib_send_wr *chain_wr);
+int rdma_rw_ctx_post(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u32 port_num,
 		struct ib_cqe *cqe, struct ib_send_wr *chain_wr);

-unsigned int rdma_rw_mr_factor(struct ib_device *device, u8 port_num,
+unsigned int rdma_rw_mr_factor(struct ib_device *device, u32 port_num,
 		unsigned int maxpages);
 void rdma_rw_init_qp(struct ib_device *dev, struct ib_qp_init_attr *attr);
 int rdma_rw_init_mrs(struct ib_qp *qp, struct ib_qp_init_attr *attr);
--
2.29.2

