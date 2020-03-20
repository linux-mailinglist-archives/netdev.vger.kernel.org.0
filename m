Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D099018D174
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 15:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgCTOsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 10:48:19 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35196 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgCTOsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 10:48:18 -0400
Received: by mail-pl1-f194.google.com with SMTP id g6so2584755plt.2
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 07:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=advWNEjbLqULQ7MVans4mnK6pbVOL0coN3/7umTAoNE=;
        b=BFaprx1EbYX4OSuvVdrMaYCqSvi7u8fMGfflsb+/GVdJEACjYZ+NRVzdoWoN1SDdEt
         A+FESFxda/8X4etmvhKP3+qKSohU7XKQWbHA1zOGAIag5S8h9nXQpgvVKdcLS3GyCJAE
         fSRFAW3TkpbNTeFvnmeEeAa7fXBatlyOmLg96rZHMN680bdpnChI1aFO1SyTd4NdLptm
         yF+oqVOYwWvK8C0LbOb79hZDoPZNXtDyoB8ddBGgQQQcYGW7bwVOdYgr9ya7l/KQDVNL
         EJvuFkXtmvo7zvWRrYdEIlvS01LPvnTozmd7iCnvba9HAq/1STIa/w/2UFGe9omdVhtg
         CTEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=advWNEjbLqULQ7MVans4mnK6pbVOL0coN3/7umTAoNE=;
        b=aHFFd3JhKwXdFwR6S1zNHV5MIYOMloGd4hK9KS1McUStkqO4c4fy071XxkmpXUWou5
         ls1hsk2bcdAfXt2vaGBBTuq2fuQoxkRWuP4XT381rtN4hDlholGZVHeag136lBJcf4Ar
         nrw2q8DYoHp2IT17pViAQbqkG83GqwNZnuVWYnzQFDNz2ISGM/A972XU48YYEXBWlfjT
         4ucivN3Cn6ffurYR+JQorIJulU1ZrLp4lcqrFuFqttyzQP+qXXkozD/FINgNYLMNjrlt
         czpRKGWtkKPsV+Svq2Q528lbdvpgWLyRdlTsjIsA5F9IvK4rIyJx3gcym9mClxMx3H6/
         ls9A==
X-Gm-Message-State: ANhLgQ0zPs372dbkYrBQY+W30rqdDXzs9FZmSgaObI2adIHmivM31Dn5
        FFF75aB7luVum55MYcKVTOgf1mb0X2ifBw==
X-Google-Smtp-Source: ADFU+vt0WthhHRUeJWgfrIaJj56/fZ+lpH6prUQMSb7PVgUCbDTIYXas11VfEq2pIHebgCP3EnFtEQ==
X-Received: by 2002:a17:902:59d8:: with SMTP id d24mr4278694plj.90.1584715696876;
        Fri, 20 Mar 2020 07:48:16 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id h15sm5777900pfq.10.2020.03.20.07.48.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 07:48:15 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: make sure accept honor rlimit nofile
To:     David Miller <davem@davemloft.net>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org
References: <20200320022216.20993-1-axboe@kernel.dk>
 <20200320022216.20993-3-axboe@kernel.dk>
 <20200319.214329.1659736613337215790.davem@davemloft.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <885293a8-7d2c-2957-ae72-9d834bcad0ed@kernel.dk>
Date:   Fri, 20 Mar 2020 08:48:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200319.214329.1659736613337215790.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/20 10:43 PM, David Miller wrote:
> From: Jens Axboe <axboe@kernel.dk>
> Date: Thu, 19 Mar 2020 20:22:16 -0600
> 
>> Just like commit 21ec2da35ce3, this fixes the fact that
>> IORING_OP_ACCEPT ends up using get_unused_fd_flags(), which checks
>> current->signal->rlim[] for limits.
>>
>> Add an extra argument to __sys_accept4_file() that allows us to pass
>> in the proper nofile limit, and grab it at request prep time.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks, added to both.

-- 
Jens Axboe

