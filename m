Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBF7243951
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 13:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgHML1I convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Aug 2020 07:27:08 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29965 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726100AbgHML1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 07:27:08 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-UcCwiyjsM8iIhg0LfJrpeA-1; Thu, 13 Aug 2020 07:27:02 -0400
X-MC-Unique: UcCwiyjsM8iIhg0LfJrpeA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5960A1007461;
        Thu, 13 Aug 2020 11:27:01 +0000 (UTC)
Received: from p50.redhat.com (ovpn-113-45.ams2.redhat.com [10.36.113.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9A2B5C1A3;
        Thu, 13 Aug 2020 11:26:59 +0000 (UTC)
From:   Stefan Assmann <sassmann@kpanic.de>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jeffrey.t.kirsher@intel.com, lihong.yang@intel.com,
        sassmann@kpanic.de, kuba@kernel.org
Subject: [PATCH v2] i40e: fix return of uninitialized aq_ret in i40e_set_vsi_promisc
Date:   Thu, 13 Aug 2020 13:26:38 +0200
Message-Id: <20200813112638.12699-1-sassmann@kpanic.de>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sassmann@kpanic.de
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: kpanic.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c: In function ‘i40e_set_vsi_promisc’:
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:1176:14: error: ‘aq_ret’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
  i40e_status aq_ret;

In case the code inside the if statement and the for loop does not get
executed aq_ret will be uninitialized when the variable gets returned at
the end of the function.

Avoid this by changing num_vlans from int to u16, so aq_ret always gets
set. Making this change in additional places as num_vlans should never
be negative.

Fixes: 37d318d7805f ("i40e: Remove scheduling while atomic possibility")
Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 8e133d6545bd..90ef810cba97 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1115,7 +1115,7 @@ static int i40e_quiesce_vf_pci(struct i40e_vf *vf)
 static int i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
 {
 	struct i40e_mac_filter *f;
-	int num_vlans = 0, bkt;
+	u16 num_vlans = 0, bkt;
 
 	hash_for_each(vsi->mac_filter_hash, bkt, f, hlist) {
 		if (f->vlan >= 0 && f->vlan <= I40E_MAX_VLANID)
@@ -1134,7 +1134,7 @@ static int i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
  *
  * Called to get number of VLANs and VLAN list present in mac_filter_hash.
  **/
-static void i40e_get_vlan_list_sync(struct i40e_vsi *vsi, int *num_vlans,
+static void i40e_get_vlan_list_sync(struct i40e_vsi *vsi, u16 *num_vlans,
 					   s16 **vlan_list)
 {
 	struct i40e_mac_filter *f;
@@ -1169,7 +1169,7 @@ static void i40e_get_vlan_list_sync(struct i40e_vsi *vsi, int *num_vlans,
  **/
 static i40e_status
 i40e_set_vsi_promisc(struct i40e_vf *vf, u16 seid, bool multi_enable,
-		     bool unicast_enable, s16 *vl, int num_vlans)
+		     bool unicast_enable, s16 *vl, u16 num_vlans)
 {
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_hw *hw = &pf->hw;
@@ -1258,7 +1258,7 @@ static i40e_status i40e_config_vf_promiscuous_mode(struct i40e_vf *vf,
 	i40e_status aq_ret = I40E_SUCCESS;
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi;
-	int num_vlans;
+	u16 num_vlans;
 	s16 *vl;
 
 	vsi = i40e_find_vsi_from_id(pf, vsi_id);
-- 
2.26.2

