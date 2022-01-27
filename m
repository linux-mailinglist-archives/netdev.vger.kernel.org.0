Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C4D49E676
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 16:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243082AbiA0Pp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 10:45:26 -0500
Received: from mga04.intel.com ([192.55.52.120]:23889 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234341AbiA0PpZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 10:45:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643298325; x=1674834325;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GYhRrfYgPBxS60sQUitUQNmC2729pcuD8+OVfqG3hiY=;
  b=ha4Ape6wE3y0ZxFrGXFYpwyE3vWMLc6dS0a1Mnwa2/cPzfZMXactB1B+
   Obpj2l9DkarpwqQrYpqsiPK0y1dNKhIHGBbwbhYfxkzIai4mFjrM2YAUQ
   +LqTkHfgNFVqdxnqWN8d4Gxm7JTUFej6xtzZSgzsc5btkx15B3fAyv9Le
   poabjtgRD9j5QQ8lil5oNRd28B/Y7GAu/sx3hf0i72+uGxjK+pnt1FycF
   0m1fACcN1BFdWiqXr60J8xJn+mXCavXRzVe3p137bcS8QJRp2uzPK86Yu
   CwqKjt4cbzvXMuqTzrd8sPBfePaUJnNGLqwf7KQp+S3hTCVtmbcyjKyv/
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="245731467"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="245731467"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 07:45:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="533149626"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 27 Jan 2022 07:45:22 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20RFjLTo029246;
        Thu, 27 Jan 2022 15:45:21 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/4] ice: switch: use a struct to pass packet template params
Date:   Thu, 27 Jan 2022 16:43:35 +0100
Message-Id: <20220127154335.623551-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <6375d82b976f18eb085859082c548b35b168cf14.camel@intel.com>
References: <20220124173116.739083-1-alexandr.lobakin@intel.com> <20220124173116.739083-4-alexandr.lobakin@intel.com> <6375d82b976f18eb085859082c548b35b168cf14.camel@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>
Date: Wed, 26 Jan 2022 22:39:38 +0100

> On Mon, 2022-01-24 at 18:31 +0100, Alexander Lobakin wrote:
> > ice_find_dummy_packet() contains a lot of boilerplate code and a
> > nice room for copy-paste mistakes.
> > Instead of passing 3 separate pointers back and forth to get packet
> > template (dummy) params, directly return a structure containing
> > them. Then, use a macro to compose compound literals and avoid code
> > duplication on return path.
> > Now, dummy packet type/name is needed only once to return a full
> > correct triple pkt-pkt_len-offsets, and those are all one-liners.
> >
> > Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> 
> This isn't applying to next-queue.

Ah, right, there's a small non-semantic conflict. I've just sent v2.

> 
> <snip>
> > @@ -4960,11 +4974,9 @@ ice_add_adv_recipe(struct ice_hw *hw, struct
> > ice_adv_lkup_elem *lkups,
> >   * @pkt_len: packet length of dummy packet
> >   * @offsets: pointer to receive the pointer to the offsets for the
> > packet
> >   */
> > -static void
> > +static struct ice_dummy_pkt_profile
> >  ice_find_dummy_packet(struct ice_adv_lkup_elem *lkups, u16
> > lkups_cnt,
> > -                     enum ice_sw_tunnel_type tun_type,
> > -                     const u8 **pkt, u16 *pkt_len,
> > -                     const struct ice_dummy_pkt_offsets **offsets)
> > +                     enum ice_sw_tunnel_type tun_type)
> 
> kdoc needs to be updated here.

Right, I somehow missed that (usually I build kernels with W=1),
sorry >_< Fixed in v2.

> 
> <snip>
> 
> >  /**
> > @@ -5104,8 +5065,7 @@ ice_find_dummy_packet(struct ice_adv_lkup_elem
> > *lkups, u16 lkups_cnt,
> >  static int
> >  ice_fill_adv_dummy_packet(struct ice_adv_lkup_elem *lkups, u16
> > lkups_cnt,
> >                           struct ice_aqc_sw_rules_elem *s_rule,
> > -                         const u8 *dummy_pkt, u16 pkt_len,
> > -                         const struct ice_dummy_pkt_offsets
> > *offsets)
> > +                         const struct ice_dummy_pkt_profile
> > *profile)
> 
> Here as well.
> 
> Thanks,
> Tony

Thanks,
Al
