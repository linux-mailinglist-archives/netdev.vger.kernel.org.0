Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 198A04D5FA2
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 11:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347982AbiCKKfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 05:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347792AbiCKKfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 05:35:40 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B129106101;
        Fri, 11 Mar 2022 02:34:36 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 81E8C218FC;
        Fri, 11 Mar 2022 10:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646994874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nZEvYyMBPYN1QtFdkQaMVNyj0XKkJ4elnymAYBJb21k=;
        b=ZS6ZRpLJmnmpCiKN0CZ3r86ITAr5TZ7YKuw20us0lnF3osuVpL90xTJ/v+NK4SyU7YdkWm
        IKGkavbso0o8v5YIWB4LbFnLFO0l6XfR2mgPKYmHMWY5Cy2lw8zalAj6pmwD3qWibMhSUP
        bdsJRB8vS66pgMEPsIct9gEAqhPkRqo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AE25F13A85;
        Fri, 11 Mar 2022 10:34:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sN5lKbklK2LxdQAAMHmgww
        (envelope-from <jgross@suse.com>); Fri, 11 Mar 2022 10:34:33 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Jens Axboe <axboe@kernel.dk>, Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org
Subject: [PATCH 2/2] xen/grant-table: remove readonly parameter from functions
Date:   Fri, 11 Mar 2022 11:34:29 +0100
Message-Id: <20220311103429.12845-3-jgross@suse.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220311103429.12845-1-jgross@suse.com>
References: <20220311103429.12845-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The gnttab_end_foreign_access() family of functions is taking a
"readonly" parameter, which isn't used. Remove it from the function
parameters.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/block/xen-blkfront.c                |  8 ++---
 drivers/char/tpm/xen-tpmfront.c             |  2 +-
 drivers/gpu/drm/xen/xen_drm_front_evtchnl.c |  2 +-
 drivers/input/misc/xen-kbdfront.c           |  4 +--
 drivers/net/xen-netfront.c                  | 13 ++++---
 drivers/pci/xen-pcifront.c                  |  2 +-
 drivers/scsi/xen-scsifront.c                |  4 +--
 drivers/usb/host/xen-hcd.c                  |  4 +--
 drivers/xen/gntalloc.c                      |  2 +-
 drivers/xen/gntdev-dmabuf.c                 |  2 +-
 drivers/xen/grant-table.c                   | 38 +++++++++------------
 drivers/xen/pvcalls-front.c                 |  6 ++--
 drivers/xen/xen-front-pgdir-shbuf.c         |  3 +-
 include/xen/grant_table.h                   |  5 ++-
 net/9p/trans_xen.c                          |  8 ++---
 sound/xen/xen_snd_front_evtchnl.c           |  2 +-
 16 files changed, 48 insertions(+), 57 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 03b5fb341e58..aa996b637d0b 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1223,7 +1223,7 @@ static void blkif_free_ring(struct blkfront_ring_info *rinfo)
 			list_del(&persistent_gnt->node);
 			if (persistent_gnt->gref != GRANT_INVALID_REF) {
 				gnttab_end_foreign_access(persistent_gnt->gref,
-							  0, 0UL);
+							  0UL);
 				rinfo->persistent_gnts_c--;
 			}
 			if (info->feature_persistent)
@@ -1246,7 +1246,7 @@ static void blkif_free_ring(struct blkfront_ring_info *rinfo)
 		       rinfo->shadow[i].req.u.rw.nr_segments;
 		for (j = 0; j < segs; j++) {
 			persistent_gnt = rinfo->shadow[i].grants_used[j];
-			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
+			gnttab_end_foreign_access(persistent_gnt->gref, 0UL);
 			if (info->feature_persistent)
 				__free_page(persistent_gnt->page);
 			kfree(persistent_gnt);
@@ -1261,7 +1261,7 @@ static void blkif_free_ring(struct blkfront_ring_info *rinfo)
 
 		for (j = 0; j < INDIRECT_GREFS(segs); j++) {
 			persistent_gnt = rinfo->shadow[i].indirect_grants[j];
-			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
+			gnttab_end_foreign_access(persistent_gnt->gref, 0UL);
 			__free_page(persistent_gnt->page);
 			kfree(persistent_gnt);
 		}
@@ -1284,7 +1284,7 @@ static void blkif_free_ring(struct blkfront_ring_info *rinfo)
 	/* Free resources associated with old device channel. */
 	for (i = 0; i < info->nr_ring_pages; i++) {
 		if (rinfo->ring_ref[i] != GRANT_INVALID_REF) {
-			gnttab_end_foreign_access(rinfo->ring_ref[i], 0, 0);
+			gnttab_end_foreign_access(rinfo->ring_ref[i], 0);
 			rinfo->ring_ref[i] = GRANT_INVALID_REF;
 		}
 	}
diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
index da5b30771418..ad0675f23e6e 100644
--- a/drivers/char/tpm/xen-tpmfront.c
+++ b/drivers/char/tpm/xen-tpmfront.c
@@ -332,7 +332,7 @@ static void ring_free(struct tpm_private *priv)
 		return;
 
 	if (priv->ring_ref)
-		gnttab_end_foreign_access(priv->ring_ref, 0,
+		gnttab_end_foreign_access(priv->ring_ref,
 				(unsigned long)priv->shr);
 	else
 		free_page((unsigned long)priv->shr);
diff --git a/drivers/gpu/drm/xen/xen_drm_front_evtchnl.c b/drivers/gpu/drm/xen/xen_drm_front_evtchnl.c
index e10d95dddb99..08b526eeec16 100644
--- a/drivers/gpu/drm/xen/xen_drm_front_evtchnl.c
+++ b/drivers/gpu/drm/xen/xen_drm_front_evtchnl.c
@@ -148,7 +148,7 @@ static void evtchnl_free(struct xen_drm_front_info *front_info,
 
 	/* end access and free the page */
 	if (evtchnl->gref != GRANT_INVALID_REF)
-		gnttab_end_foreign_access(evtchnl->gref, 0, page);
+		gnttab_end_foreign_access(evtchnl->gref, page);
 
 	memset(evtchnl, 0, sizeof(*evtchnl));
 }
diff --git a/drivers/input/misc/xen-kbdfront.c b/drivers/input/misc/xen-kbdfront.c
index 3d17a0b3fe51..1fc9b3e7007f 100644
--- a/drivers/input/misc/xen-kbdfront.c
+++ b/drivers/input/misc/xen-kbdfront.c
@@ -481,7 +481,7 @@ static int xenkbd_connect_backend(struct xenbus_device *dev,
  error_evtchan:
 	xenbus_free_evtchn(dev, evtchn);
  error_grant:
-	gnttab_end_foreign_access(info->gref, 0, 0UL);
+	gnttab_end_foreign_access(info->gref, 0UL);
 	info->gref = -1;
 	return ret;
 }
@@ -492,7 +492,7 @@ static void xenkbd_disconnect_backend(struct xenkbd_info *info)
 		unbind_from_irqhandler(info->irq, info);
 	info->irq = -1;
 	if (info->gref >= 0)
-		gnttab_end_foreign_access(info->gref, 0, 0UL);
+		gnttab_end_foreign_access(info->gref, 0UL);
 	info->gref = -1;
 }
 
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index daa4e6106aac..e2b4a1893a13 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -425,7 +425,7 @@ static bool xennet_tx_buf_gc(struct netfront_queue *queue)
 			skb = queue->tx_skbs[id];
 			queue->tx_skbs[id] = NULL;
 			if (unlikely(!gnttab_end_foreign_access_ref(
-				queue->grant_tx_ref[id], GNTMAP_readonly))) {
+				queue->grant_tx_ref[id]))) {
 				dev_alert(dev,
 					  "Grant still in use by backend domain\n");
 				goto err;
@@ -1029,7 +1029,7 @@ static int xennet_get_responses(struct netfront_queue *queue,
 			goto next;
 		}
 
-		if (!gnttab_end_foreign_access_ref(ref, 0)) {
+		if (!gnttab_end_foreign_access_ref(ref)) {
 			dev_alert(dev,
 				  "Grant still in use by backend domain\n");
 			queue->info->broken = true;
@@ -1388,7 +1388,6 @@ static void xennet_release_tx_bufs(struct netfront_queue *queue)
 		queue->tx_skbs[i] = NULL;
 		get_page(queue->grant_tx_page[i]);
 		gnttab_end_foreign_access(queue->grant_tx_ref[i],
-					  GNTMAP_readonly,
 					  (unsigned long)page_address(queue->grant_tx_page[i]));
 		queue->grant_tx_page[i] = NULL;
 		queue->grant_tx_ref[i] = GRANT_INVALID_REF;
@@ -1421,7 +1420,7 @@ static void xennet_release_rx_bufs(struct netfront_queue *queue)
 		 * foreign access is ended (which may be deferred).
 		 */
 		get_page(page);
-		gnttab_end_foreign_access(ref, 0,
+		gnttab_end_foreign_access(ref,
 					  (unsigned long)page_address(page));
 		queue->grant_rx_ref[id] = GRANT_INVALID_REF;
 
@@ -1763,7 +1762,7 @@ static void xennet_end_access(int ref, void *page)
 {
 	/* This frees the page as a side-effect */
 	if (ref != GRANT_INVALID_REF)
-		gnttab_end_foreign_access(ref, 0, (unsigned long)page);
+		gnttab_end_foreign_access(ref, (unsigned long)page);
 }
 
 static void xennet_disconnect_backend(struct netfront_info *info)
@@ -1980,14 +1979,14 @@ static int setup_netfront(struct xenbus_device *dev,
 	 */
  fail:
 	if (queue->rx_ring_ref != GRANT_INVALID_REF) {
-		gnttab_end_foreign_access(queue->rx_ring_ref, 0,
+		gnttab_end_foreign_access(queue->rx_ring_ref,
 					  (unsigned long)rxs);
 		queue->rx_ring_ref = GRANT_INVALID_REF;
 	} else {
 		free_page((unsigned long)rxs);
 	}
 	if (queue->tx_ring_ref != GRANT_INVALID_REF) {
-		gnttab_end_foreign_access(queue->tx_ring_ref, 0,
+		gnttab_end_foreign_access(queue->tx_ring_ref,
 					  (unsigned long)txs);
 		queue->tx_ring_ref = GRANT_INVALID_REF;
 	} else {
diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index d2a7b9fd678b..3edc1565a27c 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -755,7 +755,7 @@ static void free_pdev(struct pcifront_device *pdev)
 		xenbus_free_evtchn(pdev->xdev, pdev->evtchn);
 
 	if (pdev->gnt_ref != INVALID_GRANT_REF)
-		gnttab_end_foreign_access(pdev->gnt_ref, 0 /* r/w page */,
+		gnttab_end_foreign_access(pdev->gnt_ref,
 					  (unsigned long)pdev->sh_info);
 	else
 		free_page((unsigned long)pdev->sh_info);
diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 7f421600cb66..12109e4c73d4 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -757,7 +757,7 @@ static int scsifront_alloc_ring(struct vscsifrnt_info *info)
 free_irq:
 	unbind_from_irqhandler(info->irq, info);
 free_gnttab:
-	gnttab_end_foreign_access(info->ring_ref, 0,
+	gnttab_end_foreign_access(info->ring_ref,
 				  (unsigned long)info->ring.sring);
 
 	return err;
@@ -766,7 +766,7 @@ static int scsifront_alloc_ring(struct vscsifrnt_info *info)
 static void scsifront_free_ring(struct vscsifrnt_info *info)
 {
 	unbind_from_irqhandler(info->irq, info);
-	gnttab_end_foreign_access(info->ring_ref, 0,
+	gnttab_end_foreign_access(info->ring_ref,
 				  (unsigned long)info->ring.sring);
 }
 
diff --git a/drivers/usb/host/xen-hcd.c b/drivers/usb/host/xen-hcd.c
index 19b8c7ed74cb..5f4a00df4f1c 100644
--- a/drivers/usb/host/xen-hcd.c
+++ b/drivers/usb/host/xen-hcd.c
@@ -1075,14 +1075,14 @@ static void xenhcd_destroy_rings(struct xenhcd_info *info)
 	info->irq = 0;
 
 	if (info->urb_ring_ref != GRANT_INVALID_REF) {
-		gnttab_end_foreign_access(info->urb_ring_ref, 0,
+		gnttab_end_foreign_access(info->urb_ring_ref,
 					  (unsigned long)info->urb_ring.sring);
 		info->urb_ring_ref = GRANT_INVALID_REF;
 	}
 	info->urb_ring.sring = NULL;
 
 	if (info->conn_ring_ref != GRANT_INVALID_REF) {
-		gnttab_end_foreign_access(info->conn_ring_ref, 0,
+		gnttab_end_foreign_access(info->conn_ring_ref,
 					  (unsigned long)info->conn_ring.sring);
 		info->conn_ring_ref = GRANT_INVALID_REF;
 	}
diff --git a/drivers/xen/gntalloc.c b/drivers/xen/gntalloc.c
index edb0acd0b832..4849f94372a4 100644
--- a/drivers/xen/gntalloc.c
+++ b/drivers/xen/gntalloc.c
@@ -192,7 +192,7 @@ static void __del_gref(struct gntalloc_gref *gref)
 	if (gref->gref_id) {
 		if (gref->page) {
 			addr = (unsigned long)page_to_virt(gref->page);
-			gnttab_end_foreign_access(gref->gref_id, 0, addr);
+			gnttab_end_foreign_access(gref->gref_id, addr);
 		} else
 			gnttab_free_grant_reference(gref->gref_id);
 	}
diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
index 12e380db7f55..d5bfd7b867fc 100644
--- a/drivers/xen/gntdev-dmabuf.c
+++ b/drivers/xen/gntdev-dmabuf.c
@@ -533,7 +533,7 @@ static void dmabuf_imp_end_foreign_access(u32 *refs, int count)
 
 	for (i = 0; i < count; i++)
 		if (refs[i] != GRANT_INVALID_REF)
-			gnttab_end_foreign_access(refs[i], 0, 0UL);
+			gnttab_end_foreign_access(refs[i], 0UL);
 }
 
 static void dmabuf_imp_free_storage(struct gntdev_dmabuf *gntdev_dmabuf)
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 8963af8ec764..8ccccace2a4f 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -118,13 +118,12 @@ struct gnttab_ops {
 			     unsigned long frame, unsigned flags);
 	/*
 	 * Stop granting a grant entry to domain for accessing. Ref parameter is
-	 * reference of a grant entry whose grant access will be stopped,
-	 * readonly is not in use in this function. If the grant entry is
-	 * currently mapped for reading or writing, just return failure(==0)
-	 * directly and don't tear down the grant access. Otherwise, stop grant
-	 * access for this entry and return success(==1).
+	 * reference of a grant entry whose grant access will be stopped.
+	 * If the grant entry is currently mapped for reading or writing, just
+	 * return failure(==0) directly and don't tear down the grant access.
+	 * Otherwise, stop grant access for this entry and return success(==1).
 	 */
-	int (*end_foreign_access_ref)(grant_ref_t ref, int readonly);
+	int (*end_foreign_access_ref)(grant_ref_t ref);
 	/*
 	 * Read the frame number related to a given grant reference.
 	 */
@@ -270,7 +269,7 @@ int gnttab_grant_foreign_access(domid_t domid, unsigned long frame,
 }
 EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access);
 
-static int gnttab_end_foreign_access_ref_v1(grant_ref_t ref, int readonly)
+static int gnttab_end_foreign_access_ref_v1(grant_ref_t ref)
 {
 	u16 flags, nflags;
 	u16 *pflags;
@@ -286,7 +285,7 @@ static int gnttab_end_foreign_access_ref_v1(grant_ref_t ref, int readonly)
 	return 1;
 }
 
-static int gnttab_end_foreign_access_ref_v2(grant_ref_t ref, int readonly)
+static int gnttab_end_foreign_access_ref_v2(grant_ref_t ref)
 {
 	gnttab_shared.v2[ref].hdr.flags = 0;
 	mb();	/* Concurrent access by hypervisor. */
@@ -309,14 +308,14 @@ static int gnttab_end_foreign_access_ref_v2(grant_ref_t ref, int readonly)
 	return 1;
 }
 
-static inline int _gnttab_end_foreign_access_ref(grant_ref_t ref, int readonly)
+static inline int _gnttab_end_foreign_access_ref(grant_ref_t ref)
 {
-	return gnttab_interface->end_foreign_access_ref(ref, readonly);
+	return gnttab_interface->end_foreign_access_ref(ref);
 }
 
-int gnttab_end_foreign_access_ref(grant_ref_t ref, int readonly)
+int gnttab_end_foreign_access_ref(grant_ref_t ref)
 {
-	if (_gnttab_end_foreign_access_ref(ref, readonly))
+	if (_gnttab_end_foreign_access_ref(ref))
 		return 1;
 	pr_warn("WARNING: g.e. %#x still in use!\n", ref);
 	return 0;
@@ -336,7 +335,6 @@ static unsigned long gnttab_read_frame_v2(grant_ref_t ref)
 struct deferred_entry {
 	struct list_head list;
 	grant_ref_t ref;
-	bool ro;
 	uint16_t warn_delay;
 	struct page *page;
 };
@@ -360,7 +358,7 @@ static void gnttab_handle_deferred(struct timer_list *unused)
 			break;
 		list_del(&entry->list);
 		spin_unlock_irqrestore(&gnttab_list_lock, flags);
-		if (_gnttab_end_foreign_access_ref(entry->ref, entry->ro)) {
+		if (_gnttab_end_foreign_access_ref(entry->ref)) {
 			put_free_entry(entry->ref);
 			pr_debug("freeing g.e. %#x (pfn %#lx)\n",
 				 entry->ref, page_to_pfn(entry->page));
@@ -386,8 +384,7 @@ static void gnttab_handle_deferred(struct timer_list *unused)
 	spin_unlock_irqrestore(&gnttab_list_lock, flags);
 }
 
-static void gnttab_add_deferred(grant_ref_t ref, bool readonly,
-				struct page *page)
+static void gnttab_add_deferred(grant_ref_t ref, struct page *page)
 {
 	struct deferred_entry *entry;
 	gfp_t gfp = (in_atomic() || irqs_disabled()) ? GFP_ATOMIC : GFP_KERNEL;
@@ -405,7 +402,6 @@ static void gnttab_add_deferred(grant_ref_t ref, bool readonly,
 		unsigned long flags;
 
 		entry->ref = ref;
-		entry->ro = readonly;
 		entry->page = page;
 		entry->warn_delay = 60;
 		spin_lock_irqsave(&gnttab_list_lock, flags);
@@ -423,7 +419,7 @@ static void gnttab_add_deferred(grant_ref_t ref, bool readonly,
 
 int gnttab_try_end_foreign_access(grant_ref_t ref)
 {
-	int ret = _gnttab_end_foreign_access_ref(ref, 0);
+	int ret = _gnttab_end_foreign_access_ref(ref);
 
 	if (ret)
 		put_free_entry(ref);
@@ -432,15 +428,13 @@ int gnttab_try_end_foreign_access(grant_ref_t ref)
 }
 EXPORT_SYMBOL_GPL(gnttab_try_end_foreign_access);
 
-void gnttab_end_foreign_access(grant_ref_t ref, int readonly,
-			       unsigned long page)
+void gnttab_end_foreign_access(grant_ref_t ref, unsigned long page)
 {
 	if (gnttab_try_end_foreign_access(ref)) {
 		if (page != 0)
 			put_page(virt_to_page(page));
 	} else
-		gnttab_add_deferred(ref, readonly,
-				    page ? virt_to_page(page) : NULL);
+		gnttab_add_deferred(ref, page ? virt_to_page(page) : NULL);
 }
 EXPORT_SYMBOL_GPL(gnttab_end_foreign_access);
 
diff --git a/drivers/xen/pvcalls-front.c b/drivers/xen/pvcalls-front.c
index 0ca351f30a6d..e254ed19488f 100644
--- a/drivers/xen/pvcalls-front.c
+++ b/drivers/xen/pvcalls-front.c
@@ -238,8 +238,8 @@ static void pvcalls_front_free_map(struct pvcalls_bedata *bedata,
 	spin_unlock(&bedata->socket_lock);
 
 	for (i = 0; i < (1 << PVCALLS_RING_ORDER); i++)
-		gnttab_end_foreign_access(map->active.ring->ref[i], 0, 0);
-	gnttab_end_foreign_access(map->active.ref, 0, 0);
+		gnttab_end_foreign_access(map->active.ring->ref[i], 0);
+	gnttab_end_foreign_access(map->active.ref, 0);
 	free_page((unsigned long)map->active.ring);
 
 	kfree(map);
@@ -1117,7 +1117,7 @@ static int pvcalls_front_remove(struct xenbus_device *dev)
 		}
 	}
 	if (bedata->ref != -1)
-		gnttab_end_foreign_access(bedata->ref, 0, 0);
+		gnttab_end_foreign_access(bedata->ref, 0);
 	kfree(bedata->ring.sring);
 	kfree(bedata);
 	xenbus_switch_state(dev, XenbusStateClosed);
diff --git a/drivers/xen/xen-front-pgdir-shbuf.c b/drivers/xen/xen-front-pgdir-shbuf.c
index 81b6e13fa5ec..a959dee21134 100644
--- a/drivers/xen/xen-front-pgdir-shbuf.c
+++ b/drivers/xen/xen-front-pgdir-shbuf.c
@@ -143,8 +143,7 @@ void xen_front_pgdir_shbuf_free(struct xen_front_pgdir_shbuf *buf)
 
 		for (i = 0; i < buf->num_grefs; i++)
 			if (buf->grefs[i] != GRANT_INVALID_REF)
-				gnttab_end_foreign_access(buf->grefs[i],
-							  0, 0UL);
+				gnttab_end_foreign_access(buf->grefs[i], 0UL);
 	}
 	kfree(buf->grefs);
 	kfree(buf->directory);
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index 9f9b1a297f0d..dfd5bf31cfb9 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -97,7 +97,7 @@ int gnttab_grant_foreign_access(domid_t domid, unsigned long frame,
  * longer in use.  Return 1 if the grant entry was freed, 0 if it is still in
  * use.
  */
-int gnttab_end_foreign_access_ref(grant_ref_t ref, int readonly);
+int gnttab_end_foreign_access_ref(grant_ref_t ref);
 
 /*
  * Eventually end access through the given grant reference, and once that
@@ -114,8 +114,7 @@ int gnttab_end_foreign_access_ref(grant_ref_t ref, int readonly);
  * gnttab_end_foreign_access() are done via alloc_pages_exact() (and freeing
  * via free_pages_exact()) in order to avoid high order pages.
  */
-void gnttab_end_foreign_access(grant_ref_t ref, int readonly,
-			       unsigned long page);
+void gnttab_end_foreign_access(grant_ref_t ref, unsigned long page);
 
 /*
  * End access through the given grant reference, iff the grant entry is
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 01f8067994d6..77883b6788cd 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -279,13 +279,13 @@ static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
 				grant_ref_t ref;
 
 				ref = priv->rings[i].intf->ref[j];
-				gnttab_end_foreign_access(ref, 0, 0);
+				gnttab_end_foreign_access(ref, 0);
 			}
 			free_pages_exact(priv->rings[i].data.in,
 				   1UL << (priv->rings[i].intf->ring_order +
 					   XEN_PAGE_SHIFT));
 		}
-		gnttab_end_foreign_access(priv->rings[i].ref, 0, 0);
+		gnttab_end_foreign_access(priv->rings[i].ref, 0);
 		free_page((unsigned long)priv->rings[i].intf);
 	}
 	kfree(priv->rings);
@@ -353,10 +353,10 @@ static int xen_9pfs_front_alloc_dataring(struct xenbus_device *dev,
 out:
 	if (bytes) {
 		for (i--; i >= 0; i--)
-			gnttab_end_foreign_access(ring->intf->ref[i], 0, 0);
+			gnttab_end_foreign_access(ring->intf->ref[i], 0);
 		free_pages_exact(bytes, 1UL << (order + XEN_PAGE_SHIFT));
 	}
-	gnttab_end_foreign_access(ring->ref, 0, 0);
+	gnttab_end_foreign_access(ring->ref, 0);
 	free_page((unsigned long)ring->intf);
 	return ret;
 }
diff --git a/sound/xen/xen_snd_front_evtchnl.c b/sound/xen/xen_snd_front_evtchnl.c
index 29e0f0ea67eb..ecbc294fc59a 100644
--- a/sound/xen/xen_snd_front_evtchnl.c
+++ b/sound/xen/xen_snd_front_evtchnl.c
@@ -168,7 +168,7 @@ static void evtchnl_free(struct xen_snd_front_info *front_info,
 
 	/* End access and free the page. */
 	if (channel->gref != GRANT_INVALID_REF)
-		gnttab_end_foreign_access(channel->gref, 0, page);
+		gnttab_end_foreign_access(channel->gref, page);
 	else
 		free_page(page);
 
-- 
2.34.1

