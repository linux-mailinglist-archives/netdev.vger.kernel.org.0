Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C474F0682
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 23:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237299AbiDBVxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 17:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbiDBVxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 17:53:37 -0400
Received: from uriel.iewc.co.za (uriel.iewc.co.za [IPv6:2c0f:f720:0:3:d6ae:52ff:feb8:f27b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BF21FA60;
        Sat,  2 Apr 2022 14:51:41 -0700 (PDT)
Received: from [2c0f:f720:fe16:c400::1] (helo=tauri.local.uls.co.za)
        by uriel.iewc.co.za with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jaco@uls.co.za>)
        id 1nalej-0000AW-Q1; Sat, 02 Apr 2022 23:51:37 +0200
Received: from [192.168.42.201]
        by tauri.local.uls.co.za with esmtp (Exim 4.94.2)
        (envelope-from <jaco@uls.co.za>)
        id 1nalei-0001Pv-Ao; Sat, 02 Apr 2022 23:51:36 +0200
Message-ID: <e70a253d-da38-1acb-544f-81d29b72fc21@uls.co.za>
Date:   Sat, 2 Apr 2022 23:51:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP
 connections
Content-Language: en-GB
To:     Florian Westphal <fw@strlen.de>
Cc:     Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>, Wei Wang <weiwan@google.com>
References: <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
 <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za>
 <CADVnQynf8f7SUtZ8iQi-fACYLpAyLqDKQVYKN-mkEgVtFUTVXQ@mail.gmail.com>
 <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za>
 <CANn89i+Dqtrm-7oW+D6EY+nVPhRH07GXzDXt93WgzxZ1y9_tJA@mail.gmail.com>
 <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com>
 <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za>
 <CADVnQymPoyY+AX_P7k+NcRWabJZrb7UCJdDZ=FOkvWguiTPVyQ@mail.gmail.com>
 <CADVnQy=GX0J_QbMJXogGzPwD=f0diKDDxLiHV0gzrb4bo=4FjA@mail.gmail.com>
 <429dd56b-8a6c-518f-ccb4-fa5beae30953@uls.co.za>
 <20220402141410.GE28321@breakpoint.cc>
From:   Jaco Kroon <jaco@uls.co.za>
Organization: Ultimate Linux Solutions (Pty) Ltd
In-Reply-To: <20220402141410.GE28321@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On 2022/04/02 16:14, Florian Westphal wrote:
> Jaco Kroon <jaco@uls.co.za> wrote:
>> Including sysctl net.netfilter.nf_conntrack_log_invalid=6- which
>> generates lots of logs, something specific I should be looking for?  I
>> suspect these relate:
>>
>> [Sat Apr  2 10:31:53 2022] nf_ct_proto_6: SEQ is over the upper bound
>> (over the window of the receiver) IN= OUT=bond0
>> SRC=2c0f:f720:0000:0003:d6ae:52ff:feb8:f27b
>> DST=2a00:1450:400c:0c08:0000:0000:0000:001a LEN=2928 TC=0 HOPLIMIT=64
>> FLOWLBL=867133 PROTO=TCP SPT=48920 DPT=25 SEQ=2689938314 ACK=4200412020
>> WINDOW=447 RES=0x00 ACK PSH URGP=0 OPT (0101080A2F36C1C120EDFB91) UID=8
>> GID=12
> I thought this had "liberal mode" enabled for tcp conntrack?
> The above implies its off.

We have liberal on the core firewalls, not on the endpoints ... yes, we
do double firewall :).

So the firewalls into the subnets has liberal mode (which really was an
oversight when axing conntrackd), but the servers themselves do not.

Kind Regards,
Jaco

