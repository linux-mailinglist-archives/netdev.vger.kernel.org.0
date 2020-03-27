Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF681950BB
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 06:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgC0Flo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 01:41:44 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:53279 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgC0Flo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 01:41:44 -0400
Received: by mail-pj1-f66.google.com with SMTP id l36so3406148pjb.3;
        Thu, 26 Mar 2020 22:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=utegTDI4BaBUxUkWtVJ+IaSp6LMdjiJ4vzg7uGFPKxA=;
        b=e1+X8879udSlOIjF72a7Uu7b5GWEXfrrVo/KDVUeE4D+bQft9FxZNQ56Yv0rsrjZJA
         l1X9siV8idnQJhymsHdFyz7j5CsypQdzzWtRH/u8PscyUbpAqMILiWzWOSPU/m9PYQ9k
         Vt7/mtm4zh2QG6SS/hXM5nRSGAUJh5rJELqZ4GFl5FcRv+IXxWGPp+fSXnMFKReAquwm
         PIkS6AR4p7MWUsx+AaOQoaTrHSAC6BQySvkAta/iyNFm38bUoOl7UIevlRnCF8Ulwm8K
         73TiB55xrSoDiDAJ00JZQqsUW6NCKr9MCvDPLxe1C1Gdg4agFIZoU22cVN0+mp9r/zVV
         dmpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=utegTDI4BaBUxUkWtVJ+IaSp6LMdjiJ4vzg7uGFPKxA=;
        b=cSmGBd9ZehG8MlQRcd/4gmwRnvbg9caAjVSo/+MwXIDAu90EjtTJXD1DubFDbCAaZL
         s1a5+/G9b2CGEYwhcnhfQ/5wOnzMhzWx5oUC0y71KQGuRlGs/R0QUDltnBiH61TI3uXz
         0JKu5+bDKbRv0Xq4cW+6ERz/YvbGNZMB6CpnRnHURAvKlwz9RCWmrhBnrPOSbmZJ/BFG
         Gc4v8ngpH5u4NCndZBppek8CvkoU3PSV+yilyHKApp76cpN0cukMCp2ttB3eYlLWtWQc
         VrzC4a8pLcdTUee8pPAAC9EeDplVeeHgTDDkBxcQVG4BXETiHKywv4pz+erjFMoPoAdE
         lenA==
X-Gm-Message-State: ANhLgQ2BO1xDZ1KQIpguXGq+1kVddZsNCvYi7qKRBK59eF3aShkiwABZ
        dHO0WeUxMmwUB49t6PqypwbxTAYB
X-Google-Smtp-Source: ADFU+vtbufvMJnM/Ttm/YnrTVK16N7PJSxiR2OFSVpLbwEXoR1N4oO3QwB12C/lvrPoipmEnpSFN0g==
X-Received: by 2002:a17:90a:364d:: with SMTP id s71mr3794878pjb.185.1585287702936;
        Thu, 26 Mar 2020 22:41:42 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id j8sm2881137pjb.4.2020.03.26.22.41.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 22:41:41 -0700 (PDT)
Subject: Re: [PATCH v2] ipv4: fix a RCU-list lock in fib_triestat_seq_show
To:     David Miller <davem@davemloft.net>, cai@lca.pw
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200325220100.7863-1-cai@lca.pw>
 <20200326.202714.1221436401038064762.davem@davemloft.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <707e70a3-59f7-bc11-fd11-c5409e39c476@gmail.com>
Date:   Thu, 26 Mar 2020 22:41:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200326.202714.1221436401038064762.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/26/20 8:27 PM, David Miller wrote:
> From: Qian Cai <cai@lca.pw>
> Date: Wed, 25 Mar 2020 18:01:00 -0400

>> Fix it by adding a pair of rcu_read_lock/unlock() and use
>> cond_resched_rcu() to avoid the situation where walking of a large
>> number of items  may prevent scheduling for a long time.
>>
>> Signed-off-by: Qian Cai <cai@lca.pw>
> 
> Eric, please review.
> 

Patch looks good to me, thanks !

Reviewed-by: Eric Dumazet <edumazet@google.com>
