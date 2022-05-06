Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 635DE51D199
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 08:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381848AbiEFGtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 02:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381506AbiEFGsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 02:48:39 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96ED266ACE;
        Thu,  5 May 2022 23:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1651819497; x=1683355497;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FXnVciHi1BeC9OQGqN0ZXnjBw90BfiK1awUcDweGloY=;
  b=ftp+1IGDWU/0YFjqy+5c0/IlxEgkM7Y9GHxbFg4M9mpOZXVdTfhyyymd
   QGFaERVGEygvwsaL8CPjtTx7mx76EGeSEkd5qRprD97mfEo1s0se/XYFr
   i9auM0gbyXTalP1NiX/PDEPQXvMygbEhKbpa5Ut5UJPOtKea+xbtuqkkq
   c=;
X-IronPort-AV: E=Sophos;i="5.91,203,1647302400"; 
   d="scan'208";a="200507439"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-1f9d5b26.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 06 May 2022 06:44:46 +0000
Received: from EX13D08EUC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-1f9d5b26.us-west-2.amazon.com (Postfix) with ESMTPS id 5E8764181F;
        Fri,  6 May 2022 06:44:44 +0000 (UTC)
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D08EUC002.ant.amazon.com (10.43.164.124) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Fri, 6 May 2022 06:44:42 +0000
Received: from dev-dsk-mheyne-1b-c1524648.eu-west-1.amazon.com (10.15.60.66)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.32 via Frontend Transport; Fri, 6 May 2022 06:44:41 +0000
Received: by dev-dsk-mheyne-1b-c1524648.eu-west-1.amazon.com (Postfix, from userid 5466572)
        id 3198D4111F; Fri,  6 May 2022 06:44:40 +0000 (UTC)
From:   Maximilian Heyne <mheyne@amazon.de>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Maximilian Heyne <mheyne@amazon.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] drivers, ixgbe: show VF statistics
Date:   Fri, 6 May 2022 06:44:40 +0000
Message-ID: <20220506064440.57940-1-mheyne@amazon.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220504201632.2a41a3b9@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-05-04T20:16:32-07:00   Jakub Kicinski <kuba@kernel.org> wrote:

> On Tue, 3 May 2022 15:00:17 +0000 Maximilian Heyne wrote:
> > +		for (i =3D 0; i < adapter->num_vfs; i++) {
> > +			ethtool_sprintf(&p, "VF %u Rx Packets", i);
> > +			ethtool_sprintf(&p, "VF %u Rx Bytes", i);
> > +			ethtool_sprintf(&p, "VF %u Tx Packets", i);
> > +			ethtool_sprintf(&p, "VF %u Tx Bytes", i);
> > +			ethtool_sprintf(&p, "VF %u MC Packets", i);
> > +		}
> =

> Please drop the ethtool stats. We've been trying to avoid duplicating
> the same stats in ethtool and iproute2 for a while now.
> =


I can see the point that standard metrics should only be reported via the
iproute2 interface. However, in this special case this patch was intended to
converge the out-of-tree driver with the in-tree version. These missing sta=
ts
were breaking our userspace. If we now switch solely to iproute2 based
statistics both driver versions would diverge even more. So depending on wh=
ere a
user gets the ixgbe driver from, they have to work-around.

I can change the patch as requested, but it will contradict the inital
intention. At least Intel should then port this change to the external driv=
er as
well. Let's get a statement from them.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



