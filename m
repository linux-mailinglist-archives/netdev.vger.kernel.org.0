Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 841CA62C3F2
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbiKPQVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:21:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiKPQVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:21:01 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DE662CE
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 08:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668615660; x=1700151660;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TOuRXf3VZD1Ioe0nSLelAt79iji//5KrfRev4fqjfKk=;
  b=hoKOaghvbWls74/he7rCSc34odldpeThqzWf5VvskF5oIQgLIghm4o1K
   vznahVGabpE48zvaj3ThHi0BJoFXp91GZOle68jMIgVTh9IF4Rjw5uEMQ
   Rgq5A78EPC2qgoPKC5sz+L7TVECCWiBrRSe06NACF9EisE2CD1kvuPrnn
   rTmHQul45PY/2NPs4N5yCmkTySjNEcPZqtVinsfTLojaj4SiSpltQcoU6
   lBmTYiEkYVechKWchkeCIaLrhAIbVTCk68O5sxR9P31X+P4M4EFJVzddI
   F8EsOQ4AQA8dRqG73zjNZoMih4+i64HQT26p80rMS5y/WIxx8ENaLcC3+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="398874650"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="398874650"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 08:20:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="884463576"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="884463576"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 16 Nov 2022 08:20:54 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AGGKq4g004555;
        Wed, 16 Nov 2022 16:20:52 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: qualcomm: rmnet: add tx packets aggregation
Date:   Wed, 16 Nov 2022 17:20:16 +0100
Message-Id: <20221116162016.3392565-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <CAGRyCJHmNgzVVnGunUh7wwKxYA7GzSvfgqPDAxL+-NcO2P+1wg@mail.gmail.com>
References: <20221109180249.4721-1-dnlplm@gmail.com> <20221109180249.4721-3-dnlplm@gmail.com> <20221110173222.3536589-1-alexandr.lobakin@intel.com> <CAGRyCJHmNgzVVnGunUh7wwKxYA7GzSvfgqPDAxL+-NcO2P+1wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>
Date: Wed, 16 Nov 2022 16:19:48 +0100

> Hello Alexander,
> 
> Il giorno gio 10 nov 2022 alle ore 18:35 Alexander Lobakin
> <alexandr.lobakin@intel.com> ha scritto:
> >
> > Do I get the whole logics correctly, you allocate a new big skb and
> > just copy several frames into it, then send as one chunk once its
> > size reaches the threshold? Plus linearize every skb to be able to
> > do that... That's too much of overhead I'd say, just handle S/G and
> > fraglists and make long trains of frags from them without copying
> > anything?
> 
> sorry for my question, for sure I'm lacking knowledge about this, but
> I'm trying to understand how I can move forward.
> 
> Suppose I'm able to build the aggregated block as a train of
> fragments, then I have to send it to the underlying netdevice that, in
> my scenario, is created by the qmi_wwan driver: I could be wrong, but
> my understanding is that it does not support fragments.
> 
> And, as far as I know, there's only another driver in mainline used
> with rmnet (mhi_net) and that one also does not seem to support them
> either.
> 
> Does this mean that once I have the aggregated block through fragments
> it should be converted to a single linear skb before sending?

Ah okay, I've missed the fact it's only an intermediate layer and
there's some real device behind it.
If you make an skb with fragments and queue it up to a netdev which
doesn't advertise %NETIF_F_SG, networking core will take care of
this. It will then form a set of regular skbs and queue it for
sending instead. Sure, there'll be some memcopies, but I can't say
this implementation is better until some stats provided.

And BTW, as Gal indirectly mentioned, those perf problems belong to
the underlying device, e.g. qmi_wwan and so on, rmnet shouldn't do
anything here. So you could try implement aggregation there or
whatever you'd like to pick. I'd try to read some specs first and
see whether qmi_wwan HW is capable of S/G or whether some driver
improvements for Tx could be done there.

> 
> Thanks,
> Daniele

Thanks,
Olek
