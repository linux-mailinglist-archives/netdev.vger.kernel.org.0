Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5D480895
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 01:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbfHCXAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 19:00:50 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:37861 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727448AbfHCXAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 19:00:49 -0400
X-Originating-IP: 209.85.217.54
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
        (Authenticated sender: pshelar@ovn.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 8F8FF240005
        for <netdev@vger.kernel.org>; Sat,  3 Aug 2019 23:00:47 +0000 (UTC)
Received: by mail-vs1-f54.google.com with SMTP id h28so53637076vsl.12
        for <netdev@vger.kernel.org>; Sat, 03 Aug 2019 16:00:47 -0700 (PDT)
X-Gm-Message-State: APjAAAWN+eCmTL9CLk3Zaa6wzVMOf+PrRPSMlYKWsgjl6f689V9otevj
        UvQVZDyQW0gh/h+fmZ6cideHLdmMUMNGjL9yOoo=
X-Google-Smtp-Source: APXvYqxQWiYc5mDapEVk6N1ddV8fNqKU5j4Hev/Nmz52vqj/2XrVDqltO2rTiWz5n1/BqNUPUU8pkUfodDR9aNKcIs8=
X-Received: by 2002:a67:dd0a:: with SMTP id y10mr59576279vsj.93.1564873246197;
 Sat, 03 Aug 2019 16:00:46 -0700 (PDT)
MIME-Version: 1.0
References: <1564694047-4859-1-git-send-email-pkusunyifeng@gmail.com>
In-Reply-To: <1564694047-4859-1-git-send-email-pkusunyifeng@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sat, 3 Aug 2019 16:01:47 -0700
X-Gmail-Original-Message-ID: <CAOrHB_CExkSymgCU5yGKg66XywJgNxihn8VQJNr8hw6cff0rOA@mail.gmail.com>
Message-ID: <CAOrHB_CExkSymgCU5yGKg66XywJgNxihn8VQJNr8hw6cff0rOA@mail.gmail.com>
Subject: Re: [PATCH net-next] openvswitch: Print error when
 ovs_execute_actions() fails
To:     Yifeng Sun <pkusunyifeng@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 1, 2019 at 2:14 PM Yifeng Sun <pkusunyifeng@gmail.com> wrote:
>
> Currently in function ovs_dp_process_packet(), return values of
> ovs_execute_actions() are silently discarded. This patch prints out
> an error message when error happens so as to provide helpful hints
> for debugging.
>
> Signed-off-by: Yifeng Sun <pkusunyifeng@gmail.com>
> ---
>  net/openvswitch/datapath.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index 892287d..603c533 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -222,6 +222,7 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
>         struct dp_stats_percpu *stats;
>         u64 *stats_counter;
>         u32 n_mask_hit;
> +       int error;
>
>         stats = this_cpu_ptr(dp->stats_percpu);
>
> @@ -229,7 +230,6 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
>         flow = ovs_flow_tbl_lookup_stats(&dp->table, key, &n_mask_hit);
>         if (unlikely(!flow)) {
>                 struct dp_upcall_info upcall;
> -               int error;
>
>                 memset(&upcall, 0, sizeof(upcall));
>                 upcall.cmd = OVS_PACKET_CMD_MISS;
> @@ -246,7 +246,10 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
>
>         ovs_flow_stats_update(flow, key->tp.flags, skb);
>         sf_acts = rcu_dereference(flow->sf_acts);
> -       ovs_execute_actions(dp, skb, sf_acts, key);
> +       error = ovs_execute_actions(dp, skb, sf_acts, key);
> +       if (unlikely(error))
> +               net_err_ratelimited("ovs: action execution error on datapath %s: %d\n",
> +                                                       ovs_dp_name(dp), error);
>

I would rather add error counter for better visibility.
If you want to use current approach, can you use net_dbg_ratelimited()
since you want to use this for debugging purpose?

Thanks.
