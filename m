Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0AD33DE0A0
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhHBUZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhHBUZ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 16:25:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9C2060EB5;
        Mon,  2 Aug 2021 20:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627935946;
        bh=O7HnUTXVprmZ4/8oq1gddhA3XEmFUduDhZhLrUMIH2Y=;
        h=From:To:Cc:Subject:Date:From;
        b=VLb6ZLcm+8JPluUSOOKG2uWsYPoVvhY2z2qZhgx+FzVzGwVMUcMCg7d2timrMJcCy
         a+ab6rKXoYMyXbH1MsuqMvAFkG7Zuj+unTzJ3iuZsDCR6abmC3OaGHOHHMhsp0L3JI
         pEV4YVSMPUkYMri5AUTevEiB1DRAbRi6lPckODvCXhKzbZxq/fexNgUoULMZuWP5Up
         jklO48ZC14THUHASjGSn5LxJTd5fphlrQPfRv71DaecEpQjkfYOiQIVG5XY4vCLYdY
         B75TRL9KVdRGhgnVmghUZDtd6ccTEDRv/gf51zZRu08gDo+oKYNkF9x6END+oAEfQq
         LuWJBHfK2MWqQ==
From:   Mark Brown <broonie@kernel.org>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Date:   Mon,  2 Aug 2021 21:25:31 +0100
Message-Id: <20210802202531.40356-1-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/dsa/sja1105/sja1105_main.c

between commit:

  589918df9322 ("net: dsa: sja1105: be stateless with FDB entries on SJA1105P/Q/R/S/SJA1110 too")

from the net tree and commit:

  0fac6aa098ed ("net: dsa: sja1105: delete the best_effort_vlan_filtering mode")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc drivers/net/dsa/sja1105/sja1105_main.c
index 8667c9754330,5ab1676a7448..000000000000
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@@ -1445,23 -1474,25 +1499,29 @@@ int sja1105pqrs_fdb_add(struct dsa_swit
  	/* Search for an existing entry in the FDB table */
  	l2_lookup.macaddr = ether_addr_to_u64(addr);
  	l2_lookup.vlanid = vid;
 -	l2_lookup.iotag = SJA1105_S_TAG;
  	l2_lookup.mask_macaddr = GENMASK_ULL(ETH_ALEN * 8 - 1, 0);
- 	l2_lookup.mask_vlanid = VLAN_VID_MASK;
+ 	if (priv->vlan_aware) {
+ 		l2_lookup.mask_vlanid = VLAN_VID_MASK;
+ 		l2_lookup.mask_iotag = BIT(0);
+ 	} else {
+ 		l2_lookup.mask_vlanid = 0;
+ 		l2_lookup.mask_iotag = 0;
+ 	}
  	l2_lookup.destports = BIT(port);
  
 +	tmp = l2_lookup;
 +
  	rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
 -					 SJA1105_SEARCH, &l2_lookup);
 -	if (rc == 0) {
 -		/* Found and this port is already in the entry's
 +					 SJA1105_SEARCH, &tmp);
 +	if (rc == 0 && tmp.index != SJA1105_MAX_L2_LOOKUP_COUNT - 1) {
 +		/* Found a static entry and this port is already in the entry's
  		 * port mask => job done
  		 */
 -		if (l2_lookup.destports & BIT(port))
 +		if ((tmp.destports & BIT(port)) && tmp.lockeds)
  			return 0;
 +
 +		l2_lookup = tmp;
 +
  		/* l2_lookup.index is populated by the switch in case it
  		 * found something.
  		 */
@@@ -1536,8 -1537,15 +1596,14 @@@ int sja1105pqrs_fdb_del(struct dsa_swit
  
  	l2_lookup.macaddr = ether_addr_to_u64(addr);
  	l2_lookup.vlanid = vid;
 -	l2_lookup.iotag = SJA1105_S_TAG;
  	l2_lookup.mask_macaddr = GENMASK_ULL(ETH_ALEN * 8 - 1, 0);
- 	l2_lookup.mask_vlanid = VLAN_VID_MASK;
+ 	if (priv->vlan_aware) {
+ 		l2_lookup.mask_vlanid = VLAN_VID_MASK;
+ 		l2_lookup.mask_iotag = BIT(0);
+ 	} else {
+ 		l2_lookup.mask_vlanid = 0;
+ 		l2_lookup.mask_iotag = 0;
+ 	}
  	l2_lookup.destports = BIT(port);
  
  	rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
