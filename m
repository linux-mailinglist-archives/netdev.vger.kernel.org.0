Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B80D4EEC9F
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 13:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345660AbiDAL4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 07:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239256AbiDAL4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 07:56:30 -0400
Received: from uriel.iewc.co.za (uriel.iewc.co.za [IPv6:2c0f:f720:0:3:d6ae:52ff:feb8:f27b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E94D1D67ED;
        Fri,  1 Apr 2022 04:54:41 -0700 (PDT)
Received: from [2c0f:f720:fe16:c400::1] (helo=tauri.local.uls.co.za)
        by uriel.iewc.co.za with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jaco@uls.co.za>)
        id 1naFrQ-0006sK-4N; Fri, 01 Apr 2022 13:54:36 +0200
Received: from [192.168.42.201]
        by tauri.local.uls.co.za with esmtp (Exim 4.94.2)
        (envelope-from <jaco@uls.co.za>)
        id 1naFrN-0001RS-PG; Fri, 01 Apr 2022 13:54:33 +0200
Message-ID: <7d08dcfd-6ba0-f972-cee3-4fa0eff8c855@uls.co.za>
Date:   Fri, 1 Apr 2022 13:54:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP
 connections
Content-Language: en-GB
To:     Florian Westphal <fw@strlen.de>, Eric Dumazet <edumazet@google.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
References: <CADVnQyn=A9EuTwxe-Bd9qgD24PLQ02YQy0_b7YWZj4_rqhWRVA@mail.gmail.com>
 <eaf54cab-f852-1499-95e2-958af8be7085@uls.co.za>
 <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
 <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za>
 <CADVnQynf8f7SUtZ8iQi-fACYLpAyLqDKQVYKN-mkEgVtFUTVXQ@mail.gmail.com>
 <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za>
 <CANn89i+Dqtrm-7oW+D6EY+nVPhRH07GXzDXt93WgzxZ1y9_tJA@mail.gmail.com>
 <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com>
 <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za>
 <CANn89i+KsjGUppc3D8KLa4XUd-dzS3A+yDxbv2bRkDEkziS1qw@mail.gmail.com>
 <20220401001531.GB9545@breakpoint.cc>
From:   Jaco Kroon <jaco@uls.co.za>
Organization: Ultimate Linux Solutions (Pty) Ltd
In-Reply-To: <20220401001531.GB9545@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022/04/01 02:15, Florian Westphal wrote:

Incidently, I always find your initials to be interesting considering
(as far as I know) you work on netfilter firewall.

> Eric Dumazet <edumazet@google.com> wrote:
>> Next step would be to attempt removing _all_ firewalls, especially not
>> common setups like yours.
>>
>> conntrack had a bug preventing TFO deployment for a while, because
>> many boxes kept buggy kernel versions for years.
>>
>> 356d7d88e088687b6578ca64601b0a2c9d145296 netfilter: nf_conntrack: fix
>> tcp_in_window for Fast Open
> Jaco could also try with
> net.netfilter.nf_conntrack_tcp_be_liberal=1
>
> and, if that helps, with liberal=0 and
> sysctl net.netfilter.nf_conntrack_log_invalid=6
>
> (check dmesg/syslog/nflog).

Our core firewalls already had nf_conntrack_tcp_be_liberal for other
reasons (asymmetric routing combined with conntrackd left-over if I
recall), so maybe that's why it got through there ... don't exactly want
to just flip that setting though, is there a way to log if it would have
dropped anything, without actually dropping it (yet)?

Will do this first, first need to confirm that I can reproduce in a dev
environment.

Kind Regards,
Jaco


