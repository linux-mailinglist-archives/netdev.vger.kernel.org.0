Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850D626C9B6
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 21:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgIPTSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 15:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbgIPRiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 13:38:08 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C580FC0A54D6
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 05:25:51 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id gr14so10120172ejb.1
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 05:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nJ/CTVBYbV+sObz+/eFOS/tabHyZyjSxFy+JeARS5js=;
        b=06vfJejynapeS3xd7mxWli41LEAlSlfj3KrQA+rHicqamR4/+KoJ7cviKkDu0Y6gM5
         qvWylYFv1cRt7s3+K3N7r7YIBnYe1kF4UBp6uUNroOs9KeKY97tkGi3l4VDDWvBWow3w
         8t/gq4gnKSkWorcftfrMn68zCJlnSUtmE3eQUQYA9oIjnWsqQptbQKrdOlXELPRZMl73
         6K+XBkOi7QWpJ7RJIZB393IR73lOSFbzLRXPe1R2JDGuX15NE6GSDVtAC5393ue5G1qA
         afQe/Il4okrNXxP+RrXHfrzJ48r5C4Lq57lRTlsOEIlSXakTL4LfFh0DOR4kYfQkCEHn
         ma1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nJ/CTVBYbV+sObz+/eFOS/tabHyZyjSxFy+JeARS5js=;
        b=JUMcrwN0dDcpP8EUnw9f7QyNiGkAXZ4n3XLazNw0aktESHoMQBxkfkYEO9aLlKcjFV
         KB5gmbRAWF4oor67b+8sE4A2N0BZrZNov90wTeduCWoziOAz23Ks86sR35jaS/2AUrIz
         DzO6vfx1MOIm9K/S+pazfrN30Nevb2RG+QBXU51FyzlTgSJ8h68t/uLSDYKs1MsU1cO/
         Pdl0NLJW57eDes91XPucRVcsnbe+qI5iiXmVaCuiH/+yLxJmrTluuvS1Dfe+GL00qtnk
         i9QSly2E3BBYCa92sXTJlT9MPeqBY3XmILol7tl/b+5wOv3m5HdryHOvxApCvmpjpHY/
         zKHA==
X-Gm-Message-State: AOAM530TUO41nM2U2LVqngPPL+KQ0X77c5OtXUip3HI6prAnhygeKzM6
        +a2DBYGt6kXs2zV7Fo7ut6pJ/A==
X-Google-Smtp-Source: ABdhPJwQIkRa8JSa0SghwpmFKkHgnFurUfYNxwg4c1z9zKkfuf0fTKNlPIM7mMK26FlcU4qBgKB0jQ==
X-Received: by 2002:a17:906:344e:: with SMTP id d14mr26050404ejb.42.1600259150320;
        Wed, 16 Sep 2020 05:25:50 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([77.109.98.55])
        by smtp.gmail.com with ESMTPSA id z17sm14486949edi.90.2020.09.16.05.25.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2020 05:25:49 -0700 (PDT)
Subject: Re: [PATCH v2] mptcp: Fix unsigned 'max_seq' compared with zero in
 mptcp_data_queue_ofo
To:     Ye Bin <yebin10@huawei.com>, mathew.j.martineau@linux.intel.com,
        netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Hulk Robot <hulkci@huawei.com>
References: <20200916114104.1556846-1-yebin10@huawei.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <f947d64e-5970-7022-1a06-964c7dfbbd03@tessares.net>
Date:   Wed, 16 Sep 2020 14:23:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200916114104.1556846-1-yebin10@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ye,

Thank you for this v2.

On 16/09/2020 13:41, Ye Bin wrote:
> Fixes coccicheck warnig:
> net/mptcp/protocol.c:164:11-18: WARNING: Unsigned expression compared with zero: max_seq > 0
> 
> Fixes: ab174ad8ef76 ("mptcp: move ooo skbs into msk out of order queue")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>   net/mptcp/protocol.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index ef0dd2f23482..3b71f6202524 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -155,13 +155,14 @@ static void mptcp_data_queue_ofo(struct mptcp_sock *msk, struct sk_buff *skb)
>   {
>   	struct sock *sk = (struct sock *)msk;
>   	struct rb_node **p, *parent;
> +	int space;
>   	u64 seq, end_seq, max_seq;
>   	struct sk_buff *skb1;

In the network subsystem, variables have to be declared following the 
"reverse Xmas tree" order: longest to shortest line length.

Could you then please move your new variable to the end of the list, 
under skb1?

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
