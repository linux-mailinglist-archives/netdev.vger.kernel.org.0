Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1294FC956
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 02:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbiDLAlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 20:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiDLAlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 20:41:06 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6D41929A
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 17:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649723931; x=1681259931;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=zdDESkkqaUn/aPwGR2fRNE+tXm7huVy2jT6kk0Wyssc=;
  b=a/jrw3bAgviCSC0BdYcYUqpPQHP2A7xa4SA4pBrarnI9zVhZVI1FbQhg
   mcn3+uvQgYS965yND2dypVtU+YEwA61oImZ6BADQktllIWBzCosWdBuUH
   62+ntapjBK1rHOXFwg9sGWSXyAiPJBJMfsVDmzUGH6OEuSci2FHL1W1pN
   gtpuebZ2dzsWx9JVVbUTuRHC7SuJLDZfzYqc9VAbKh17pqth41sASsjOb
   TfS36WjbmPIQ5n0YKSVVvs4W1HwzVw07hcH8D0Siex1Om9BUtLHx7BLvQ
   YgLzsuKLfLG9iaEA9bY1SdJ4RAGsEBE4Au2kPY4DPT9J+0aMBHUlf8iGV
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10314"; a="249529238"
X-IronPort-AV: E=Sophos;i="5.90,252,1643702400"; 
   d="scan'208";a="249529238"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 17:38:47 -0700
X-IronPort-AV: E=Sophos;i="5.90,252,1643702400"; 
   d="scan'208";a="551466016"
Received: from vcostago-mobl3.jf.intel.com (HELO vcostago-mobl3) ([10.24.14.61])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 17:38:47 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v4 02/12] taprio: Add support for frame
 preemption offload
In-Reply-To: <20220412000759.wtsebxkayb5vssvx@skbuf>
References: <20210626003314.3159402-1-vinicius.gomes@intel.com>
 <20210626003314.3159402-3-vinicius.gomes@intel.com>
 <20210627195826.fax7l4hd2itze4pi@skbuf> <874k2zdwp4.fsf@intel.com>
 <20220412000759.wtsebxkayb5vssvx@skbuf>
Date:   Mon, 11 Apr 2022 17:38:47 -0700
Message-ID: <87h76zcezs.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> On Mon, Apr 11, 2022 at 04:31:03PM -0700, Vinicius Costa Gomes wrote:
>> > First line in taprio_disable_offload() is:
>> >
>> > 	if (!FULL_OFFLOAD_IS_ENABLED(q->flags))
>> > 		return 0;
>> >
>> > but you said it yourself below that the preemptible queues thing is
>> > independent of whether you have taprio offload or not (or taprio at
>> > all). So the queues will never be reset back to the eMAC if you don't
>> > use full offload (yes, this includes txtime offload too). In fact, it's
>> > so independent, that I don't even know why we add them to taprio in the
>> > first place :)
>>
>> That I didn't change taprio_disable_offload() was a mistake caused in
>> part by the limitations of the hardware I have (I cannot have txtime
>> offload and frame preemption enabled at the same time), so I didn't
>> catch that.
>>
>> > I think the argument had to do with the hold/advance commands (other
>> > frame preemption stuff that's already in taprio), but those are really
>> > special and only to be used in the Qbv+Qbu combination, but the pMAC
>> > traffic classes? I don't know... Honestly I thought that me asking to
>> > see preemptible queues implemented for mqprio as well was going to
>> > discourage you, but oh well...
>>
>> Now, the real important part, if this should be communicated to the
>> driver via taprio or via ethtool/netlink.
>>
>> I don't really have strong opinions on this anymore, the two options are
>> viable/possible.
>>
>> This is going to be a niche feature, agreed, so thinking that going with
>> the one that gives the user more flexibility perhaps is best, i.e. using
>> ethtool/netlink to communicate which queues should be marked as
>> preemptible or express.
>
> So we're back at this, very well.
>
> I was just happening to be looking at clause 36 of 802.1Q (Priority Flow Control),
> a feature exchanged through DCBX where flows of a certain priority can be
> configured as lossless on a port, and generate PAUSE frames. This is essentially
> the extension of 802.3 annex 31B MAC Control PAUSE operation with the ability to
> enable/disable flow control on a per-priority basis.
>
> The priority in PFC (essentially synonymous with "traffic class") is the same
> priority as the priority in frame preemption. And you know how PFC is configured
> in Linux? Not through the qdisc, but through DCB_ATTR_PFC_CFG, a nested dcbnl
> netlink attribute with one nested u8 attribute per priority value
> (DCB_PFC_UP_ATTR_0 to DCB_PFC_UP_ATTR_7).
>
> Not saying we should follow the exact same model as PFC, just saying that I'm
> hard pressed to find a good reason why the "preemptable traffic classes"
> information should sit in a layer which is basically independent of the frame
> preemption feature itself.

Ok, going to take this as another point in favor of going the ethtool
route.


Thank you,
-- 
Vinicius
