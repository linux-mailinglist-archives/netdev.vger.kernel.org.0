Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6FDD535064
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 16:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347605AbiEZONP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 10:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbiEZONO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 10:13:14 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7E3C1ED0;
        Thu, 26 May 2022 07:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653574393; x=1685110393;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qUfNjncTCj5hZWQBBEaqTdJWLymKO7ddU2o85+SJ4Gk=;
  b=kUJYKPL9Tf+ntJTXnNyRR7r+gG+FqFTHkIhKEX/vYJd3AF1EiQm2cpbe
   TQQpyNFpQf2g8+Z/3QJdrSGthfbaB+RYZizQm272VR8jS5LgZw8VU1LTA
   DYhVT+u+QFKvXvTlJg0u3K1wYfqzPPR3WDgFlHPBh59bSwUlO4T5eFo6U
   kbUnii7CU2S0HtrHkWksaAlgcpZkURCobU7K6M/IRcL3msGKzJMVUMnI7
   VhJz7Hb8bF9CeQSZDpMGZTDnF8KyOeqP83EJETX0Fb1LZ0L8LwyqFIDyH
   tFSlvZ0f8e8Z0zTOIsIjlBMdccsumZUDjcCfrDo3bN8M/TbvQvhs8iHmL
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10359"; a="299503691"
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="299503691"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2022 07:13:12 -0700
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="549604750"
Received: from unknown (HELO s240.localdomain) ([10.237.94.19])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2022 07:13:09 -0700
From:   Piotr Skajewski <piotrx.skajewski@intel.com>
To:     intel-wired-lan@lists.osuosl.org, olivier.matz@6wind.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        pmenzel@molgen.mpg.de, stable@vger.kernel.org,
        nicolas.dichtel@6wind.com, alexandr.lobakin@intel.com,
        maciej.fijalkowski@intel.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com
Subject: [Intel-wired-lan] [PATCH net v2 0/2] ixgbe: fix promiscuous mode on VF
Date:   Thu, 26 May 2022 16:10:15 +0200
Message-Id: <20220526141015.43057-1-piotrx.skajewski@intel.com>
X-Mailer: git-send-email 2.35.0.rc0
In-Reply-To: <20220406095252.22338-1-olivier.matz@6wind.com>
References: <20220406095252.22338-1-olivier.matz@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, Apr 25, 2022 at 01:51:53PM +0200, Olivier Matz wrote:
> > Hi,
> > 
> > On Wed, Apr 06, 2022 at 11:52:50AM +0200, Olivier Matz wrote:
> > > These 2 patches fix issues related to the promiscuous mode on VF.
> > > 
> > > Comments are welcome,
> > > Olivier
> > > 
> > > Cc: stable@vger.kernel.org
> > > Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> > > 
> > > Changes since v1:
> > > - resend with CC intel-wired-lan
> > > - remove CC Hiroshi Shimamoto (address does not exist anymore)
> > > 
> > > Olivier Matz (2):
> > >   ixgbe: fix bcast packets Rx on VF after promisc removal
> > >   ixgbe: fix unexpected VLAN Rx in promisc mode on VF
> > > 
> > >  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > Any feedback about this patchset?
> > Comments are welcome.
>
> I didn't get feedback for this patchset until now. Am I doing things
> correctly? Am I targeting the appropriate mailing lists and people?
>
> Please let me know if I missed something.

Hi Olivier,

Sorry for the late reply,
We had to analyze it internally and it took us some time.
After reviewing, we decided that the proposed patches could be accepted.

ACK for series.

Thanks,
Piotr
