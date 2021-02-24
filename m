Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6BFC32454C
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 21:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235655AbhBXUfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 15:35:47 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:19003 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhBXUfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 15:35:43 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1614198755; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=odsDwFjEYdfA5fcy5cR9tiEdNvmFHn+pKzHvMW98ODONhFDpUotNR6Le55l0gSR1Sk
    Gl+5W98tasj8PKmzjnFSnn/QvwBqlO6RafDrglVp4ph2MdUafo7N5aKOcYAuIwWIvF7l
    jBFzD2i3pFgvGCjLCuvcnp8tibzejBEicEkQMgGJUwp/ayvcKN20vmMvLiyWhz8YsuDA
    oXBx/BOg5/4eZNtotxS26EL2ns9su3Hfoowigk/PVw53dl+Vt9RSXFhchxxM/rQc9f1k
    XputsSH4ZIHrdxzlXLndgmuy3Eqk5ZcRoVph6t7i1LVc3t2Wb3Q3Sn/tLp7Zvhb7TIMG
    FbOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1614198755;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=aC1Oqi0gTCBRh71ZBeFShz0zjWZcHdK+/jHi3+gDnLs=;
    b=M/VC1z8GJSlqaSH5c0eWBfyFGVAnGx1h58r3RgNWxlII9QC4uFnlMnH/cYTN2epdFj
    vGjpML7OxbT1S2Fch68z7CltfsvINHWaxUWKRbLyBD9mo5+/gxANf2PpZy0AVqb/BzrA
    2mtwE/PXCzx7rI9j7yVF06jqmXtUweBDAaTJXftx8ZgUZZvbyAh36WWdlaCmP98lv3Fo
    wkXXp5Xb/fzPIJ7OKiIEvhmF1E+IEx5lSOgHRqGi9DEBy5g9bazXioRglyIjlHUJBMau
    RM4k9dk1+2f/wagua7UMZoORYXTAYPH5ZNu4b4olbYTZ+KUXp+1rGTlNLW6vBR8Ogw8w
    nHRA==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1614198755;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=aC1Oqi0gTCBRh71ZBeFShz0zjWZcHdK+/jHi3+gDnLs=;
    b=TKTl2BmArHFa/WMPOGV1JrDkfmRL6iTYUuliFEffB1vkfxhULsa2R52PM5LS2B2X41
    fvxMiwGTVatwTWYSDSDbW/XYO4lYjkutw8iJw/sGgB2Gib8XEWq1H6JCuBJnoLtxlZHX
    N7prqFjJ+JA3mw6NEkgORVTmwyqO6EjhV4xr1rU16ekrGxecrJcMjFLmH7IKTfaKNTHY
    AoxK2akC3T8mr2PcxLtI6Ca1o5hKdwj3t8Xavukjq/qt9+HNvXTom/lUiH10DAUH/Dc0
    NWBqtD5N1p+8aS6/sbc1sLosPLuu5MLiakzC8TiZID+soHHHQaKNJGXgVhJ/I+PuigWl
    e1qA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJV8h5kkV6"
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
    by smtp.strato.de (RZmta 47.19.0 DYNA|AUTH)
    with ESMTPSA id V003bex1OKWYD2m
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 24 Feb 2021 21:32:34 +0100 (CET)
Subject: Re: [PATCH net v3 1/1] can: can_skb_set_owner(): fix ref counting if
 socket was closed before setting skb ownership
To:     Eric Dumazet <edumazet@google.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Robin van der Gracht <robin@protonic.nl>,
        Andre Naujoks <nautsch2@gmail.com>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210224075932.20234-1-o.rempel@pengutronix.de>
 <CANn89iLEHpCphH8vKd=0BS7pgdP1YZDGqQfQPeGBkD09RoHtzg@mail.gmail.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <76ec5c10-c051-7a52-9ae7-04af79a0e9e5@hartkopp.net>
Date:   Wed, 24 Feb 2021 21:32:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CANn89iLEHpCphH8vKd=0BS7pgdP1YZDGqQfQPeGBkD09RoHtzg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24.02.21 09:53, Eric Dumazet wrote:
> On Wed, Feb 24, 2021 at 8:59 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>>
>> There are two ref count variables controlling the free()ing of a socket:
>> - struct sock::sk_refcnt - which is changed by sock_hold()/sock_put()
>> - struct sock::sk_wmem_alloc - which accounts the memory allocated by
>>    the skbs in the send path.
>>
>> In case there are still TX skbs on the fly and the socket() is closed,
>> the struct sock::sk_refcnt reaches 0. In the TX-path the CAN stack
>> clones an "echo" skb, calls sock_hold() on the original socket and
>> references it. This produces the following back trace:
>>
>> | WARNING: CPU: 0 PID: 280 at lib/refcount.c:25 refcount_warn_saturate+0x114/0x134
>> | refcount_t: addition on 0; use-after-free.
>> | Modules linked in: coda_vpu(E) v4l2_jpeg(E) videobuf2_vmalloc(E) imx_vdoa(E)
>> | CPU: 0 PID: 280 Comm: test_can.sh Tainted: G            E     5.11.0-04577-gf8ff6603c617 #203
>> | Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
>> | Backtrace:
>> | [<80bafea4>] (dump_backtrace) from [<80bb0280>] (show_stack+0x20/0x24) r7:00000000 r6:600f0113 r5:00000000 r4:81441220
>> | [<80bb0260>] (show_stack) from [<80bb593c>] (dump_stack+0xa0/0xc8)
>> | [<80bb589c>] (dump_stack) from [<8012b268>] (__warn+0xd4/0x114) r9:00000019 r8:80f4a8c2 r7:83e4150c r6:00000000 r5:00000009 r4:80528f90
>> | [<8012b194>] (__warn) from [<80bb09c4>] (warn_slowpath_fmt+0x88/0xc8) r9:83f26400 r8:80f4a8d1 r7:00000009 r6:80528f90 r5:00000019 r4:80f4a8c2
>> | [<80bb0940>] (warn_slowpath_fmt) from [<80528f90>] (refcount_warn_saturate+0x114/0x134) r8:00000000 r7:00000000 r6:82b44000 r5:834e5600 r4:83f4d540
>> | [<80528e7c>] (refcount_warn_saturate) from [<8079a4c8>] (__refcount_add.constprop.0+0x4c/0x50)
>> | [<8079a47c>] (__refcount_add.constprop.0) from [<8079a57c>] (can_put_echo_skb+0xb0/0x13c)
>> | [<8079a4cc>] (can_put_echo_skb) from [<8079ba98>] (flexcan_start_xmit+0x1c4/0x230) r9:00000010 r8:83f48610 r7:0fdc0000 r6:0c080000 r5:82b44000 r4:834e5600
>> | [<8079b8d4>] (flexcan_start_xmit) from [<80969078>] (netdev_start_xmit+0x44/0x70) r9:814c0ba0 r8:80c8790c r7:00000000 r6:834e5600 r5:82b44000 r4:82ab1f00
>> | [<80969034>] (netdev_start_xmit) from [<809725a4>] (dev_hard_start_xmit+0x19c/0x318) r9:814c0ba0 r8:00000000 r7:82ab1f00 r6:82b44000 r5:00000000 r4:834e5600
>> | [<80972408>] (dev_hard_start_xmit) from [<809c6584>] (sch_direct_xmit+0xcc/0x264) r10:834e5600 r9:00000000 r8:00000000 r7:82b44000 r6:82ab1f00 r5:834e5600 r4:83f27400
>> | [<809c64b8>] (sch_direct_xmit) from [<809c6c0c>] (__qdisc_run+0x4f0/0x534)
>>
>> To fix this problem, only set skb ownership to sockets which have still
>> a ref count > 0.
>>
>> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
>> Cc: Andre Naujoks <nautsch2@gmail.com>
>> Suggested-by: Eric Dumazet <edumazet@google.com>
>> Fixes: 0ae89beb283a ("can: add destructor for self generated skbs")
>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> 
> SGTM
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> 
>> ---
>>   include/linux/can/skb.h | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
>> index 685f34cfba20..655f33aa99e3 100644
>> --- a/include/linux/can/skb.h
>> +++ b/include/linux/can/skb.h
>> @@ -65,8 +65,7 @@ static inline void can_skb_reserve(struct sk_buff *skb)
>>
>>   static inline void can_skb_set_owner(struct sk_buff *skb, struct sock *sk)
>>   {
>> -       if (sk) {
>> -               sock_hold(sk);

Although the commit message gives a comprehensive reason for this patch: 
Can you please add some comment here as I do not think the use of 
refcount_inc_not_zero() makes clear what is checked here.

Many thanks,
Oliver


>> +       if (sk && refcount_inc_not_zero(&sk->sk_refcnt)) {
>>                  skb->destructor = sock_efree;
>>                  skb->sk = sk;
>>          }
>> --
>> 2.29.2
>>
