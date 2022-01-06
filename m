Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B1F48637B
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 12:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238277AbiAFLID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 06:08:03 -0500
Received: from mail-yb1-f170.google.com ([209.85.219.170]:39883 "EHLO
        mail-yb1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238271AbiAFLIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 06:08:02 -0500
Received: by mail-yb1-f170.google.com with SMTP id d1so6298883ybh.6;
        Thu, 06 Jan 2022 03:08:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=akSXOJTvhkoL+q7qfV0Sgx52WY/d9LuGeFB94caA1hQ=;
        b=k9I9G2N6jjOc6cprB2nXcIt2Sey1myjpTykRfAZ0Eb88pFIt7EovIRgMMPpFaryD9t
         I/jJFG0ftcRZEB+uaH3FAbc0XvSZ7smHFG3cDymVYLaGhoqOsyYSHX7SQyO+tnWj9WYl
         EM6Q/MqZKSOFODxU7YXGv4XfNf+tYcAjGAR242eMpyyAIAQHdxF4Vv1MYUxnCLM6WwG8
         MRt0f25kLRs3x7YYyMYwq0l1GM4xOoGZYPUwcc4Lb5H7OTt7So7vxgcW7jLzmVrLozky
         r1Ta2R/4j7ATShs/2X0oRjeIn7iL0M05hAvysy5/LFjAd121LTPyRJxn7hRqkbUjKtem
         N7ug==
X-Gm-Message-State: AOAM530cEXyWwad05HH/afHz/ztlLfxLSplMRCJ4KFvMK72eu5b8pLFI
        Xt1VPgeNhCkvIc+Cuxd3+ujjBMwglOK0kDqwYpkDKuF48X4=
X-Google-Smtp-Source: ABdhPJxHYQGGFrzqrexNXMq8ag8ZroJDK38JCp75B121Jm/aAZAzzS5sACJ3WYHSMVy5I3QW6/cnJlShZQFAo8BT2Qw=
X-Received: by 2002:a25:9205:: with SMTP id b5mr55180742ybo.2.1641467281703;
 Thu, 06 Jan 2022 03:08:01 -0800 (PST)
MIME-Version: 1.0
References: <20220106102937.2824-1-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20220106102937.2824-1-mailhol.vincent@wanadoo.fr>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 6 Jan 2022 20:07:50 +0900
Message-ID: <CAMZ6Rq+hrAu=mDPHw1yXhw9UKhQiSe3E9p6agudOzqbgo9sDtA@mail.gmail.com>
Subject: Re: [RFC PATCH v3] iplink_can: add ctrlmode_{supported,_static} to
 the "--details --json" output
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

First of all, let me which a happy new year to the members of the
linux-can mailing list (and to the members of the other mailings
in CC as well).

I am not fully confident of how to format the output. Above patch
is my best shot, but I would like to gather other people's
opinion on two topics before dropping the RFC tag.

On Tue, 6 Jan. 2022 at 19:29, Vincent Mailhol
<mailhol.vincent@wanadoo.fr> wrote:
> This patch is the userland counterpart of [1]. Indeed, [1] allows the
> can netlink interface to report the CAN controller capabilities.
>
> Previously, only the options which were switched on were reported
> (i.e. can_priv::ctrlmode). Here, we add two additional pieces of
> information to the json report:
>
>   - ctrlmode_supported: the options that can be modified by netlink
>
>   - ctrlmode_static: option which are statically enabled by the driver
>     (i.e. can not be turned off)
>
> For your information, we borrowed the naming convention from struct
> can_priv [2].
>
> Contrary to the ctrlmode, the ctrlmode_{supported,_static} are only
> reported in the json context. The reason is that this newly added
> information can quickly become very verbose and we do not want to
> overload the default output. You can think of the "ip --details link
> show canX" output as the verbose mode and the "ip --details --json
> link show canX" output as the *very* verbose mode.
>
> *Example:*
>
> This is how the output would look like for a dummy driver which would
> have:
>
>   - CAN_CTRLMODE_LOOPBACK, CAN_CTRLMODE_LISTENONLY,
>     CAN_CTRLMODE_3_SAMPLES, CAN_CTRLMODE_FD, CAN_CTRLMODE_CC_LEN8_DLC
>     and TDC-AUTO supported by the driver
>
>   - CAN_CTRLMODE_CC_LEN8_DLC turned on by the user
>
>   - CAN_CTRLMODE_FD_NON_ISO statically enabled by the driver
>
> | $ ip link set can0 type can cc-len8-dlc on
> | $ ip --details --json --pretty link show can0
> | [ {
> |         "ifindex": 1,
> |         "ifname": "can0",
> |         "flags": [ "NOARP","ECHO" ],
> |         "mtu": 16,
> |         "qdisc": "noop",
> |         "operstate": "DOWN",
> |         "linkmode": "DEFAULT",
> |         "group": "default",
> |         "txqlen": 10,
> |         "link_type": "can",
> |         "promiscuity": 0,
> |         "min_mtu": 0,
> |         "max_mtu": 0,
> |         "linkinfo": {
> |             "info_kind": "can",
> |             "info_data": {
> |                 "ctrlmode": [ "FD-NON-ISO","CC-LEN8-DLC" ],
> |                 "ctrlmode_supported": [ "LOOPBACK","LISTEN-ONLY","TRIPLE-SAMPLING","FD","CC-LEN8-DLC","TDC-AUTO" ],
> |                 "ctrlmode_static": [ "FD-NON-ISO" ],

Here, I propose to just add two new members to the json
object "info_data".

One alternative option I am thinking of is to group everything
under a new json object called "ctrlmode" like that:

|             "info_data": {
|                 "ctrlmode": {
|                     "enabled": [ "FD-NON-ISO","CC-LEN8-DLC" ],
|                     "supported": [
"LOOPBACK","LISTEN-ONLY","TRIPLE-SAMPLING","FD","CC-LEN8-DLC","TDC-AUTO"
],
|                     "static": [ "FD-NON-ISO" ]
|                 },
|                 "state": "STOPPED",
|                 ...

The drawback of doing so is that it would break any tools relying
on the current format to retrieve the ctrlmode enabled
features. For example, this command:

| ip --details --json --pretty link show can0 | jq
'.[].linkinfo.info_data.ctrlmode'

will yield a different result before and after the change.

So here is my question: it is acceptable to break current format?
If yes, I would prefer the alternate solution listed here, if
not, I will keep things as proposed in this RFC.

> |                 "state": "STOPPED",
> |                 "restart_ms": 0,
> |                 "bittiming_const": {
> |                     "name": "DUMMY_CAN_DEV",
> |                     "tseg1": {
> |                         "min": 2,
> |                         "max": 256
> |                     },
> |                     "tseg2": {
> |                         "min": 2,
> |                         "max": 128
> |                     },
> |                     "sjw": {
> |                         "min": 1,
> |                         "max": 128
> |                     },
> |                     "brp": {
> |                         "min": 1,
> |                         "max": 512
> |                     },
> |                     "brp_inc": 1
> |                 },
> |                 "data_bittiming_const": {
> |                     "name": "DUMMY_CAN_DEV",
> |                     "tseg1": {
> |                         "min": 2,
> |                         "max": 32
> |                     },
> |                     "tseg2": {
> |                         "min": 1,
> |                         "max": 16
> |                     },
> |                     "sjw": {
> |                         "min": 1,
> |                         "max": 8
> |                     },
> |                     "brp": {
> |                         "min": 1,
> |                         "max": 32
> |                     },
> |                     "brp_inc": 1,
> |                     "tdc": {
> |                         "tdco": {
> |                             "min": 0,
> |                             "max": 127
> |                         },
> |                         "tdcf": {
> |                             "min": 0,
> |                             "max": 127
> |                         }
> |                     }
> |                 },
> |                 "clock": 80000000
> |             }
> |         },
> |         "num_tx_queues": 1,
> |         "num_rx_queues": 1,
> |         "gso_max_size": 65536,
> |         "gso_max_segs": 65535,
> |         "parentbus": "usb",
> |         "parentdev": "1-10:1.1"
> |     } ]
>
> As mentioned above, the default output remains unchanged:
>
> | $ ip --details link show can0
> | 1: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
> |     link/can  promiscuity 0 minmtu 0 maxmtu 0
> |     can <FD-NON-ISO,CC-LEN8-DLC> state STOPPED restart-ms 0

If had a long thought and couldn't come with anything pretty for
the default (non-json) output. My best idea is to use some
suffixes, something like that:

    '-' to indicate that the feature is supported but disabled.

    '+' to indicate that the feature is supported and enabled.

    '*' to indicate a static feature.

If I reuse the example used in above json output, that would
become:

| $ ip --details link show can0
| 1: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT
group default qlen 10
|     link/can  promiscuity 0 minmtu 0 maxmtu 0
|     can <LOOPBACK-,LISTEN-ONLY-,TRIPLE-SAMPLING-,FD-,FD-NON-ISO*,CC-LEN8-DLC+,TDC-AUTO->
state STOPPED restart-ms 0
|         DUMMY_CAN_DEV: tseg1 2..256 tseg2 2..128 sjw 1..128 brp
1..512 brp_inc 1

I don't think this is easy to read.

Another option is to output three arrays, similar to the json
output. But I think that this is too busy. So my preferred
solution is to do no changes. Does this make sense? Or would you
still prefer to have the enabled and static features reported in
the normal output as well? And if yes, in which format?

> |         DUMMY_CAN_DEV: tseg1 2..256 tseg2 2..128 sjw 1..128 brp 1..512 brp_inc 1
> |         DUMMY_CAN_DEV: dtseg1 2..32 dtseg2 1..16 dsjw 1..8 dbrp 1..32 dbrp_inc 1
> |         tdco 0..127 tdcf 0..127
> |         clock 80000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 parentbus usb parentdev 1-10:1.1

That's all for my current doubts. If I receive no feedback by the
end of the week, I will assume that everyone is happy with this
RFC and will resend the patch without the RFC tag to have it
included in iproute 5.17.

Thank you,


Yours sincerely,
Vincent Mailhol
