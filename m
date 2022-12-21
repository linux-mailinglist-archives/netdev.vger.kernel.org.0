Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41756652F28
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 11:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbiLUKLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 05:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbiLUKLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 05:11:42 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3262BB5;
        Wed, 21 Dec 2022 02:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671617502; x=1703153502;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dYD+UOcopJsu69rx7QvL08so4v21YBItNo/dRI4ekMA=;
  b=ho2NGsQ163r/HmBwTLdePkULKfGUx6F9jDZ2Ynd8ppBmXy7N7ATYKGwh
   rQ2LFG1Yemiqp1T9HO2U/apIHZG56OhUtpLXlMqQBB1PLyzq8p5Vm95Lo
   BtZRiJU+WOEPx+4aJzqUU9/XCoCwULRk38EzRmZaQxF297ZE/IClXf51R
   60y3xAo7NT/lJGJ9MxhRKuVmbFBK3v5SskpROhsCPu6aplCouvVEV3pQL
   jMl1jxTl6kZHozNKSMEdyOmmmsXb8Yc45AZRcEsa+wJkJKKIbr1sAsx2B
   vlloLZvMzM0aSD8T1tkoEkto9MoOW5GWbEIbM8bjn6Uh5rdh/LPX0f9L0
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="321014536"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="321014536"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 02:11:41 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="793653088"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="793653088"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 02:11:38 -0800
Date:   Wed, 21 Dec 2022 11:11:29 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Aaron Conole <aconole@redhat.com>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, dev@openvswitch.org,
        Eelco Chaudron <echaudro@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        wangchuanlei <wangchuanlei@inspur.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: openvswitch: release vport resources on failure
Message-ID: <Y6Lbxykp9n3EzDQS@localhost.localdomain>
References: <20221220212717.526780-1-aconole@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220212717.526780-1-aconole@redhat.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 04:27:17PM -0500, Aaron Conole wrote:
> A recent commit introducing upcall packet accounting failed to properly
> release the vport object when the per-cpu stats struct couldn't be
> allocated.  This can cause dangling pointers to dp objects long after
> they've been released.
> 
> Cc: Eelco Chaudron <echaudro@redhat.com>
> Cc: wangchuanlei <wangchuanlei@inspur.com>
> Fixes: 1933ea365aa7 ("net: openvswitch: Add support to count upcall packets")
> Reported-by: syzbot+8f4e2dcfcb3209ac35f9@syzkaller.appspotmail.com
> Signed-off-by: Aaron Conole <aconole@redhat.com>
> ---
Looks good, thanks

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> -- 
> 2.31.1
> 
