Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A16E6E5089
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 21:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjDQTED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 15:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjDQTEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 15:04:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D8849DD
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 12:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681758199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lLVVDt+triVjF5VYRCYZc23sSOOLV7muSmlqbcqOICQ=;
        b=Pn+IMtGmcEEcvcj09BcPneX0v1rxdVh+IpdvO3vo09vN13XGnSAGHgNTNucO13dPD7Pprc
        hxvHMra6DRSSmYLEdjw0OukN9D8UB0uqRG8Z6kDaeUV7zJCQP8OU0dPuCcwVOlRrOWTtRx
        mpeXoHz4DZX8ELZSAUYV9o4oShQ34Qs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-149-aDgWuPOvOFykdleZBocnaQ-1; Mon, 17 Apr 2023 15:03:15 -0400
X-MC-Unique: aDgWuPOvOFykdleZBocnaQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C43783DE3E;
        Mon, 17 Apr 2023 19:03:15 +0000 (UTC)
Received: from calimero.vinschen.de (unknown [10.39.195.69])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9624347CD0;
        Mon, 17 Apr 2023 19:03:14 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 9992DA808C0; Mon, 17 Apr 2023 21:03:12 +0200 (CEST)
Date:   Mon, 17 Apr 2023 21:03:12 +0200
From:   Corinna Vinschen <vinschen@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        alexandre.torgue@foss.st.com, Jose Abreu <joabreu@synopsys.com>
Subject: Re: [PATCH net-next] net: stmmac: propagate feature flags to vlan
Message-ID: <ZD2X8ALO3m7dmbOu@calimero.vinschen.de>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        alexandre.torgue@foss.st.com, Jose Abreu <joabreu@synopsys.com>
References: <20230411130028.136250-1-vinschen@redhat.com>
 <20230412211513.2d6fc1f7@kernel.org>
 <ZDgfBEnxLWczPLQO@calimero.vinschen.de>
 <20230413090040.44aa0d55@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230413090040.44aa0d55@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Apr 13 09:00, Jakub Kicinski wrote:
> On Thu, 13 Apr 2023 17:25:56 +0200 Corinna Vinschen wrote:
> > I tested that I can, for instance, set and reset the tx-checksumming
> > flag with ethtool -K.  As for TSO, I checked the source code, and the
> > function stmmac_tso_xmit handles VLANs just fine.  While different
> > NICs supported by stmmac have different offload features, there's no
> > indication in the driver source that VLANs have less offloading features
> > than a non-VLAN connection on the same HW.  Admittedly, I never saw
> > documentation explicitely claiming this.
> > 
> > If that's not sufficient, testing will take another day or two, because
> > I have to ask for a remote test setup first.
> 
> Testing would be great, I think it's worth waiting for that.

Yes, that was a good idea.  Turns out, TSO doesn't really work well
with VLANs.  The speed is... suboptimal.  Here are some results
with iperf, showing only the summary lines.

Base interface with TSO off:

$ ethtool -K enp0s29f1 tso off
$ iperf3 -c 192.168.1.2
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1015 MBytes   852 Mbits/sec    0             sender
[  5]   0.00-10.04  sec  1012 MBytes   845 Mbits/sec                  receiver

Base interface with TSO on:

$ ethtool -K enp0s29f1 tso on
$ iperf3 -c 192.168.1.2
[...]
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.08 GBytes   928 Mbits/sec    0             sender
[  5]   0.00-10.04  sec  1.08 GBytes   921 Mbits/sec                  receiver

VLAN interface with TSO off:

$ ethtool -K enp0s29f1 tso off
$ iperf3 -c 192.168.3.2
[...]
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec   975 MBytes   818 Mbits/sec    0             sender
[  5]   0.00-10.04  sec   973 MBytes   813 Mbits/sec                  receiver

VLAN interface with TSO on:

$ ethtool -K enp0s29f1 tso on
$ iperf3 -c 192.168.3.2
[...]
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  16.0 MBytes  13.4 Mbits/sec  899             sender
[  5]   0.00-10.04  sec  15.9 MBytes  13.3 Mbits/sec                  receiver

Oops.

I'll send a v2 patch which disables TSO on VLANs for the time being.


Corinna

