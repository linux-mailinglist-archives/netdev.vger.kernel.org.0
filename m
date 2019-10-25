Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA6CE561C
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 23:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbfJYVpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 17:45:39 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:44111 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbfJYVpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 17:45:38 -0400
Received: by mail-il1-f196.google.com with SMTP id f13so3075705ils.11
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 14:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KSmmoXpgZgZZPMYFzmD/g27FCNe11Jnk66TJmTgerKc=;
        b=lILpxe+dSD4ZqxhlWaZZugrBzAtaGP2t5gk7ACVmzl15g128OUt/KN4IW9OlZrWbvX
         iwHlyi662oPotQf8iIVESpoNVT47YrZ52Jflq9j4XxCNYfZ7SeZJXcU6GIsV6XkTJziJ
         2ExGk6KBBQTHjRm0bbPXs3Zg9HHuLL7bugOsf9KVtiM5+fDepsEFbtWZVBGGC909oq4p
         3B2tMaH9pm70b89rkW/4uumkTXv6uxHnhU21cPNn8VlJkmHOz/7LYn1moClrcSA7wQmw
         lUxLIdsAJPhirVBhGEJ0DBqgAJN7zJH6M4ioC8LEt7wRmRSlpHwGWmIrZPI9vSlQZtmx
         vCMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KSmmoXpgZgZZPMYFzmD/g27FCNe11Jnk66TJmTgerKc=;
        b=lsIKFSUlR+buAHiyVvBBVyrtRkoIwej0NMZbC2Y+ycZr3MhhUbGj8gjfPGSNe1gLuv
         RlHBUDY5SwN7ixrNljEA5Be9JNiH/BkEzajLEEaHR0h+XHtikXY+7fG47NVHcgqehx0Y
         k1PJTfgJJaNR1A6gHaAIx02IfLFdojuMlm8N/bVBZhh0eS0YjzPzBZpFC9jIwdYeAP/Q
         X+Zg4AFVuliIt+G0wJxYl41ceBLIOEV+ZrzyJCX5y7yikz5PPhgpNx0q4Kz8Kr7Y4/bn
         wmR3o8gWbpcvn6TSrL5Bf1rroFjIQGkDBhnfN0kB5dQXRBNlaeUN3EHAhLOLV5WE5X1p
         s7VA==
X-Gm-Message-State: APjAAAWncg4/7MC+N5M79ThQ69rsWpEpULqFoAoL3E3G8zZBRKbvyFq6
        WJgVbdTYBpANnQm5AiZXQLoZ7w==
X-Google-Smtp-Source: APXvYqz/y5GlAsCN1ZBMSeWQkipoXLxSAIdIvtlbEegDLbX2VTABTXFerzq6H09Zjvkz3ZXhRikjvQ==
X-Received: by 2002:a05:6e02:c02:: with SMTP id d2mr7075626ile.261.1572039936417;
        Fri, 25 Oct 2019 14:45:36 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w75sm498961ill.78.2019.10.25.14.45.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 14:45:35 -0700 (PDT)
Subject: Re: [PATCH 2/4] io_uring: io_uring: add support for async work
 inheriting files
To:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-block@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jannh@google.com
References: <20191025173037.13486-1-axboe@kernel.dk>
 <20191025173037.13486-3-axboe@kernel.dk>
 <c33f7137-5b54-c588-f4e8-dd7e1e03edf3@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0ea19a52-a1cf-ae8a-82d7-f4ffb3c0286b@kernel.dk>
Date:   Fri, 25 Oct 2019 15:45:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <c33f7137-5b54-c588-f4e8-dd7e1e03edf3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/25/19 3:31 PM, Pavel Begunkov wrote:
> On 25/10/2019 20:30, Jens Axboe wrote:
>> +static int io_grab_files(struct io_ring_ctx *ctx, struct io_kiocb *req)
>> +{
>> +	int ret = -EBADF;
>> +
>> +	rcu_read_lock();
>> +	spin_lock_irq(&ctx->inflight_lock);
>> +	/*
>> +	 * We use the f_ops->flush() handler to ensure that we can flush
>> +	 * out work accessing these files if the fd is closed. Check if
>> +	 * the fd has changed since we started down this path, and disallow
>> +	 * this operation if it has.
>> +	 */
>> +	if (fcheck(req->submit.ring_fd) == req->submit.ring_file) {
> Can we get here from io_submit_sqes()?
> ring_fd will be uninitialised in this case.

We can't, we disallow submission of any opcode (for now just accept)
from the sq thread that needs a file table.

-- 
Jens Axboe

