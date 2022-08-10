Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 277D058EC18
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 14:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbiHJMgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 08:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiHJMgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 08:36:24 -0400
Received: from louie.mork.no (louie.mork.no [IPv6:2001:41c8:51:8a:feff:ff:fe00:e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4CB8053B;
        Wed, 10 Aug 2022 05:36:23 -0700 (PDT)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9d:7e00:0:0:0:1])
        (authenticated bits=0)
        by louie.mork.no (8.15.2/8.15.2) with ESMTPSA id 27ACZa9F599307
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 13:35:37 +0100
Received: from miraculix.mork.no ([IPv6:2a01:799:961:910a:a293:6d6e:8bbf:c204])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 27ACZUMD651068
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 14:35:30 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1660134931; bh=PNPycATN8VpMrxdiigaDnAXZauhanlnMGxj1GP+uRdM=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=PAC5HFFSC/gd+dZIaXRmoAFqL8ui+F8zwmFf1sfSxzuenJRbPb7hV1EtUvNQygvJt
         UKAI5BbDcNYOVLxt2P5EOnT5J93FFQLFSwNONfcSh/+UMmAvGiYUK2RLIPcqqcB7Rr
         8pcS7xo9RLU4tQqIbvw80+oqww5eSCX/67UdVa1E=
Received: (nullmailer pid 484366 invoked by uid 1000);
        Wed, 10 Aug 2022 12:35:25 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: qmi_wwan: Add support for Cinterion MV32
Organization: m
References: <20220810014521.9383-1-slark_xiao@163.com>
        <8735e4mvtd.fsf@miraculix.mork.no>
        <e7fdcfc.30e7.1828715d7af.Coremail.slark_xiao@163.com>
        <61ca0e63.3207.18287214d7a.Coremail.slark_xiao@163.com>
Date:   Wed, 10 Aug 2022 14:35:24 +0200
In-Reply-To: <61ca0e63.3207.18287214d7a.Coremail.slark_xiao@163.com> (Slark
        Xiao's message of "Wed, 10 Aug 2022 17:41:22 +0800 (CST)")
Message-ID: <87mtccl1ir.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.6 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Slark Xiao" <slark_xiao@163.com> writes:
> At 2022-08-10 17:28:51, "Slark Xiao" <slark_xiao@163.com> wrote:
>
>>I have a concern, if Cinterion or other Vendors, like Quectel, use other=
=20
>>chip (such as intel, mediateck and so on), this methods may won't work,
>
> My bad. QMI_WWAN driver is designed for Qualcomm based chips only,
> =C2=A0right?=20

Yes, but your concern is still valid if any of them re-use ff/ff/50 for
something which is not RMNET/QMI.  We do not want this driver to start
matching a non-Qualcomm based device.

>>because  they share a same VID. Also this may be changed once Qualcomm=20
>>update the protocol patterns for future chip.

Yes, that' a risk since we have no knowledge of Qualcomm's plans or
thoughts around this. It's all pure guesswork from my side.  But as
such, it doesn't differ from the rest of this driver :-) Qualcomm can
change whatever they want and we'll just have to follow up with whatever
is required. Like what happened when raw-ip became mandatory.

I do find it unlikely that Qualcomm will ever change the meaning of this
pattern now that they've started using it.  That would not make any
sense. If they need to create a new vendor specific function type, then
they can just use one of the "free" protocol numbers (and also subclass
if they run out of protocol numbers).

But it's your call.  If you want to play it safe and keep the VID+PID
matching, then I'm fine with that too.


Bj=C3=B8rn
