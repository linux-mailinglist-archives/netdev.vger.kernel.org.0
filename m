Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D72DE363B7
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 21:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfFETGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 15:06:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38294 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfFETGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 15:06:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EBB681510C91D;
        Wed,  5 Jun 2019 12:05:59 -0700 (PDT)
Date:   Wed, 05 Jun 2019 12:05:59 -0700 (PDT)
Message-Id: <20190605.120559.1335640243691845984.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mcroce@redhat.com
Subject: Re: [PATCH net] pktgen: do not sleep with the thread lock held.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7fed17636f7a9d51b0603c8a4cfdd2111cd946e1.1559737968.git.pabeni@redhat.com>
References: <7fed17636f7a9d51b0603c8a4cfdd2111cd946e1.1559737968.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 12:06:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Wed,  5 Jun 2019 14:34:46 +0200

> @@ -3062,20 +3062,49 @@ static int thread_is_running(const struct pktgen_thread *t)
>  	return 0;
>  }
>  
> -static int pktgen_wait_thread_run(struct pktgen_thread *t)
> +static bool pktgen_lookup_thread(struct pktgen_net *pn, struct pktgen_thread *t)
> +{
> +	struct pktgen_thread *tmp;
> +
> +	list_for_each_entry(tmp, &pn->pktgen_threads, th_list)
> +		if (tmp == t)
> +			return true;
> +	return false;
> +}

Pointer equality is not object equality.

It is possible for a pktgen thread to be terminated, a new one started,
and the new one to have the same pointer value as the old one.
