Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41D1129C19
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390668AbfEXQXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:23:12 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33056 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389588AbfEXQXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:23:12 -0400
Received: by mail-pg1-f195.google.com with SMTP id h17so5340468pgv.0
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QXD06cIHV87SUpJ2OlWe9Bj7n6Is9RKC2fJSdthm6Wk=;
        b=GMQOx477GiiEpg2XLVAT6RgsN6Pm7WbPjEykASw9y7cIWbUUI004iSMRqtQNiE+NFi
         CCdsfYleZnTfMLy1cNfMIE33g0tWtSuTXRFt3zpgz3eGx0bFKM7nTSoIZ1DZdt7PCglW
         dv6sgScLFxvSTwOEv6hed6LbSIdxRMdrWpgR0v85/n76UGnZXkbPMYe2rH2gDV6nx/Wv
         /Gq3GbxjUII+U+XxUvKrbVhp3fUDhR8YYcepwJRJzkcLVhkWZQlH4qe2FTOJ3HT3Pk0M
         kK5HQzb7w7p77H0raFSDP5FJD+EEBWhlntwRklfj2K/HG28Nomw+GTYFstvVbcWHqOsu
         N3Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QXD06cIHV87SUpJ2OlWe9Bj7n6Is9RKC2fJSdthm6Wk=;
        b=i/hMFeitMEIbBc6Ha1wulUeapnV8e1nX3bsRKeMh9ZxcoKtASlwUEMLLrJC3szG4NQ
         gnL/lwhYL0Edbm6bjuip9fyl3J/TCoxhb5+qXO9m8rfAUfNwI2k8rm6iv4jUK8lTFtn5
         vChBdGbK3RDYVLN4IvAPDcoIZSZJWlaizf2OoDn7EaoQhKtizVx+xdsGLdhVdsoyjirQ
         /ue0mw4ylRk0OfCEf0o8FkkScOn7QANgFCOjnniEu5q/vhx6k1NbNi73OoXjkkXJzxm3
         BOB2jC8O+xulTP3gFp1G1ZUgJrhHpvir61tq7ttB1qZO4NCXRNOSYb5KvX6HKSA95vIR
         1lSA==
X-Gm-Message-State: APjAAAWfaV1L+kMply6/J21AISk+gKByUjkAQZ/xwP4olpNI/p6WxXGo
        TqwikFEWNz9ayHktcWws7oIVTQ==
X-Google-Smtp-Source: APXvYqzmblRXzUZvq0llzFjM9AxRA+j/ZYX7t82fV5NfIdYMK0570lZXbWK31bYhKwgKZpWSED+iQA==
X-Received: by 2002:a17:90a:c682:: with SMTP id n2mr10679911pjt.31.1558714991244;
        Fri, 24 May 2019 09:23:11 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d88sm8737094pfm.42.2019.05.24.09.23.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 09:23:11 -0700 (PDT)
Date:   Fri, 24 May 2019 09:23:04 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     John Hurley <john.hurley@netronome.com>
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, davem@davemloft.net,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com
Subject: Re: [RFC net-next 1/1] net: sched: protect against loops in TC
 filter hooks
Message-ID: <20190524092304.55457922@hermes.lan>
In-Reply-To: <1558713946-25314-1-git-send-email-john.hurley@netronome.com>
References: <1558713946-25314-1-git-send-email-john.hurley@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 May 2019 17:05:46 +0100
John Hurley <john.hurley@netronome.com> wrote:

> TC hooks allow the application of filters and actions to packets at both
> ingress and egress of the network stack. It is possible, with poor
> configuration, that this can produce loops whereby an ingress hook calls
> a mirred egress action that has an egress hook that redirects back to
> the first ingress etc. The TC core classifier protects against loops when
> doing reclassifies but, as yet, there is no protection against a packet
> looping between multiple hooks. This can lead to stack overflow panics.
> 
> Add a per cpu counter that tracks recursion of packets through TC hooks.
> The packet will be dropped if a recursive limit is passed and the counter
> reset for the next packet.
> 
> Signed-off-by: John Hurley <john.hurley@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>
> ---
>  net/core/dev.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 55 insertions(+), 7 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index b6b8505..a6d9ed7 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -154,6 +154,9 @@
>  /* This should be increased if a protocol with a bigger head is added. */
>  #define GRO_MAX_HEAD (MAX_HEADER + 128)
>  
> +#define SCH_RECURSION_LIMIT	4
> +static DEFINE_PER_CPU(int, sch_recursion_level);

Maybe use unsigned instead of int?

> +
>  static DEFINE_SPINLOCK(ptype_lock);
>  static DEFINE_SPINLOCK(offload_lock);
>  struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
> @@ -3598,16 +3601,42 @@ int dev_loopback_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
>  }
>  EXPORT_SYMBOL(dev_loopback_xmit);
>  
> +static inline int sch_check_inc_recur_level(void)
> +{
> +	int rec_level = __this_cpu_inc_return(sch_recursion_level);
> +
> +	if (rec_level >= SCH_RECURSION_LIMIT) {
unlikely here?

> +		net_warn_ratelimited("Recursion limit reached on TC datapath, probable configuration error\n");

It would be good to know which device this was on.

> +		return -ELOOP;
> +	}
> +
> +	return 0;
> +}
> +
> +static inline void sch_dec_recur_level(void)
> +{
> +	__this_cpu_dec(sch_recursion_level);

Decrement of past 0 is an error that should be trapped and logged.

> +}
> +
>  #ifdef CONFIG_NET_EGRESS
>  static struct sk_buff *
>  sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
>  {
>  	struct mini_Qdisc *miniq = rcu_dereference_bh(dev->miniq_egress);
>  	struct tcf_result cl_res;
> +	int err;
>  
>  	if (!miniq)
>  		return skb;
>  
> +	err = sch_check_inc_recur_level();
> +	if (err) {
> +		sch_dec_recur_level();

You should have sch_check_inc_recur_level do the unwind on error.
That would simplify the error paths.

> +		*ret = NET_XMIT_DROP;
> +		consume_skb(skb);
> +		return NULL;
> +	}
> +

