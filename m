Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC0B11FABC
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 20:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfLOTWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 14:22:18 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40450 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfLOTWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 14:22:18 -0500
Received: by mail-pg1-f195.google.com with SMTP id k25so2394619pgt.7
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 11:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=F0rXRC47sH0LlMz2dLOYKgOdE43jP9P3n2Oc173UFo8=;
        b=hCwjUgSX+6QNk3DdS/hcYJq+5f7bBw2Id8mloM7TaJ4FPUddaR2FbEhI2xUhid40F7
         oXJ+J7tgsXI6BmOOOQc+V9MdwpCClF/ifhER8r4LokKby88vXaod8lIY37QPRQtRe6vX
         LYAG/O586ISWn4YSCo2mWgk8hlKIo+4CpJsxD/KzAsh8m3CkOreTilQvVA1pyg1WViKo
         Zq5t8ocUVIkyE0b5KD1S3oyCX1p9eKEGK7kgpSB6PQPVJ3SqdI6fXf6wTYXthoBYOlDJ
         gun5ob58m5VjCmMJ6UaMq4X/1qnvr2qRokeRh+MbhL2iCpGF5IhF0TnX7Js3Ujr5wFwS
         AxJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=F0rXRC47sH0LlMz2dLOYKgOdE43jP9P3n2Oc173UFo8=;
        b=WVoAk7eWJo3m0eD18+XrNmrhWMVZXeGtoIenMaz7Za7JmwRVXRQS9Y4Q3goSxaJeOH
         Ya+8OCsqynS+D5a9ueoUAl2NplORDZNeqBImequMIeKssS1MNngloVCV0QlQyB9/W7+4
         jsIUsUpMQMPHbeSchoJPdeE8k3MYeZ8yYMIvcr4Jq5y5DV84JNoOaUVPFy1D6OUWuo1S
         2y49FPtN/whhb3ke2d/YxiXatuqOF/Uh3061jf7M611rify+UkS/tlOIdVbfA0nvMAAy
         yE4YKLSG7CubE9acoXwZtievGIjJujrWgoRNQU+CQ31uGFGJy985LWb4174XQHjnhwDu
         zO3w==
X-Gm-Message-State: APjAAAV+7BujM+cx7V1w8snLwrIl2aH+R3Ed3sZsOVjfjvDxjUZq26S6
        2IYDORpInO2nXCt3tFwXeTnr7Q==
X-Google-Smtp-Source: APXvYqw/MbNZ/nc+SKPW0c63bTrTlDKDX8Ck6OxS6jWYjnR3ltb4PZAShUAOH/dfCuM2iiaDRvOD8Q==
X-Received: by 2002:a63:534d:: with SMTP id t13mr13145618pgl.89.1576437737625;
        Sun, 15 Dec 2019 11:22:17 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id h9sm19058804pfo.139.2019.12.15.11.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 11:22:17 -0800 (PST)
Date:   Sun, 15 Dec 2019 11:22:14 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, arjunroy@google.com,
        soheil@google.com, edumazet@google.com
Subject: Re: [PATCH net-next] tcp: Set rcv zerocopy hint correctly if skb
 last frag is < PAGE_SIZE.
Message-ID: <20191215112214.3dd72168@cakuba.netronome.com>
In-Reply-To: <20191212225930.233745-1-arjunroy.kdev@gmail.com>
References: <20191212225930.233745-1-arjunroy.kdev@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 14:59:30 -0800, Arjun Roy wrote:
> At present, if the last frag of paged data in a skb has < PAGE_SIZE
> data, we compute the recv_skip_hint as being equal to the size of that
> frag and the entire next skb.
> 
> Instead, just return the runt frag size as the hint.

nit: this commit message doesn't really tell us why or what the effects
     are going to be.

> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

WARNING: Missing Signed-off-by: line by nominal patch author 'Arjun Roy <arjunroy.kdev@gmail.com>'

You gotta send it from the same address you signed it off from.
 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 34490d972758..b9623d896469 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1904,6 +1904,8 @@ static int tcp_zerocopy_receive(struct sock *sk,
>  	while (length + PAGE_SIZE <= zc->length) {
>  		if (zc->recv_skip_hint < PAGE_SIZE) {
>  			if (skb) {
> +				if (zc->recv_skip_hint > 0)
> +					break;
>  				skb = skb->next;
>  				offset = seq - TCP_SKB_CB(skb)->seq;
>  			} else {

