Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B597B653676
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 19:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbiLUSks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 13:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234889AbiLUSkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 13:40:37 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF47326ACE;
        Wed, 21 Dec 2022 10:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671648032; x=1703184032;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=a867+PQTcf3q7dV+YtX1oSNkLuA7GD548wpUTuf/lCw=;
  b=aSDSwlxQyAU1eG6SE+5phvzneNEhaeZnoyD5NX7BC/ipAVXbT7iKiPJO
   QnSBsMOYMPTvRp34bHyr1s5F1fL73Tcz8T3XMqzV9ZCEz8bVMHJkpOX57
   hlASCCblk5koF3THJ3B9tcS7vwt+gTDDgNARi4HCeMK+jWFc1/xXztpxL
   BvfSmq91BGhGTHC//LATHLXHmqE0K6C3XbBhG3zZCROuf1/tYdgh26FCH
   78z8QlFcF5i4gVxzhxQzpvRHIje6lTKpiTSayToz5h5bpuws8JQWc7n+q
   vLREkSr5+FMnsk+7Wvs50R+XGlFHfVJ/ir5tpk0ZdgQbhGotKQH7lqwxp
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10568"; a="307628301"
X-IronPort-AV: E=Sophos;i="5.96,263,1665471600"; 
   d="scan'208";a="307628301"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 10:40:32 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10568"; a="896936893"
X-IronPort-AV: E=Sophos;i="5.96,263,1665471600"; 
   d="scan'208";a="896936893"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 10:40:29 -0800
Date:   Wed, 21 Dec 2022 19:40:26 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] qlcnic: prevent ->dcb use-after-free on
 qlcnic_dcb_enable() failure
Message-ID: <Y6NTGjcM8aUE0M5w@localhost.localdomain>
References: <20221220125649.1637829-1-d-tatianin@yandex-team.ru>
 <Y6G5eWWucdaJXmQu@localhost.localdomain>
 <8c49acd6-7195-caaf-425c-b9ed9290423d@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c49acd6-7195-caaf-425c-b9ed9290423d@yandex-team.ru>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 21, 2022 at 10:47:29AM +0300, Daniil Tatianin wrote:
> On 12/20/22 4:32 PM, Michal Swiatkowski wrote:
> > On Tue, Dec 20, 2022 at 03:56:49PM +0300, Daniil Tatianin wrote:
> > > adapter->dcb would get silently freed inside qlcnic_dcb_enable() in
> > > case qlcnic_dcb_attach() would return an error, which always happens
> > > under OOM conditions. This would lead to use-after-free because both
> > > of the existing callers invoke qlcnic_dcb_get_info() on the obtained
> > > pointer, which is potentially freed at that point.
> > > 
> > > Propagate errors from qlcnic_dcb_enable(), and instead free the dcb
> > > pointer at callsite.
> > > 
> > > Found by Linux Verification Center (linuxtesting.org) with the SVACE
> > > static analysis tool.
> > > 
> > > Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
> > 
> > Please add Fix tag and net as target (net-next is close till the end of
> > this year)
> > 
> Sorry, I'll include a fixes tag.
> Could you please explain what I would have to do to add net as target?

Sorry, maybe it was bad wording. I meant to have PATCH net v2 in title.
For example by adding to git format-patch:
--subject-prefix="PATCH net v2"

> > > ---
> > >   drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c | 9 ++++++++-
> > >   drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h       | 5 ++---
> > >   drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c      | 9 ++++++++-
> > >   3 files changed, 18 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
> > > index dbb800769cb6..465f149d94d4 100644
> > > --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
> > > +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
> > > @@ -2505,7 +2505,14 @@ int qlcnic_83xx_init(struct qlcnic_adapter *adapter)
> > >   		goto disable_mbx_intr;
> > >   	qlcnic_83xx_clear_function_resources(adapter);
> > > -	qlcnic_dcb_enable(adapter->dcb);
> > > +
> > > +	err = qlcnic_dcb_enable(adapter->dcb);
> > > +	if (err) {
> > > +		qlcnic_clear_dcb_ops(adapter->dcb);
> > > +		adapter->dcb = NULL;
> > > +		goto disable_mbx_intr;
> > > +	}
> > 
> > Maybe I miss sth but it looks like there can be memory leak.
> > For example if error in attach happen after allocating of dcb->cfg.
> > Isn't it better to call qlcnic_dcb_free instead of qlcnic_clear_dcb_ops?
> I think you're right, if attach fails midway then we might leak cfg or
> something else.
> I'll use qlcnic_dcb_free() instead and completely remove
> qlcnic_clear_dcb_ops() as it
> seems to be unused and relies on dcb being in a very specific state.

Great, thanks

[...]
