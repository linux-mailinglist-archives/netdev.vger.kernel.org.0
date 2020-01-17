Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 852B214030D
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 05:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbgAQEoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 23:44:08 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:44600 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgAQEoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 23:44:07 -0500
Received: by mail-ot1-f67.google.com with SMTP id h9so21470928otj.11;
        Thu, 16 Jan 2020 20:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OdUWGX2M44tSJxq5HwG1zjlZE4dOmKxmhrCev3Miwp8=;
        b=oatErtAN9cujlGfvxd67rW2u2R6rptLrE6wQw6K3mNaZTjpKcA4rbeoQYE6SoEKm5F
         qblp13XkNiWSpaYKjK9ihugs5wd2QcMpxBMaBVItSIwaVXQLV66puyeqV9xzGAzNx7H7
         in4okX31UY4ETYs3WlMX8amPulzy1uReNkdx3PJUqrUVPRE5UGfoimXD2TCQgaF4CTd7
         PABdOdJ5wt7D3LNOpaU1640xCpDx44gA0tIo2TX2vs7qjfOslMbByc9mLMDqtLFIU7SO
         6L+tOeQ57OhIbUVd5pby4jnHuyId9BdjkQxqUNkLE4ANQ4gwJawj26ucX4/eLhefR4mb
         3Tlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OdUWGX2M44tSJxq5HwG1zjlZE4dOmKxmhrCev3Miwp8=;
        b=em6bWssylOp4kjOf3fmqJ4QBXnPAIWm4XJNTTW7jQbZQnXefEZW5wkLRpPKPz8q2n8
         mzjLBrAhqNkcHQU/gKdJp6P9lhlDdSjwr3aH9CGz5RRSdTxNZU/kCYOq31cVNOQX5uX0
         vvcIXLSJR5OOlvgjjUPkv+l09uchPTJlLOZanIrX1hv4XzTxSP4qP6l7WheEC5YJEwOj
         mgPBwBTV2pOtnlEX42Dwb5XUzkQufwbih2rmN0uy+GG8RF1kWED8xGC6RYHgr42jWVsp
         uztdznyYn0cyHOYbfBICWolF6J4BpNrnpy6KUjMIhKX3n+xHLPjKAl3zdK3qAo3lHZva
         oG4g==
X-Gm-Message-State: APjAAAWH0+8OdXAZvgeuPdXqeaCAnYcPyZDWVN5Emu8XWRQ0iIVV7Tpq
        zmnBIszHTR6qhhYQWvqF6kaLjecQ3u7HbBUwvj3qWU+Ra7M=
X-Google-Smtp-Source: APXvYqwVjaXTDchluzQRQuOOm8EBIYP0UCLXeZm5JMVd9PzBDfHiGQPPJL+p2blHDaI2Qm4bojUXdGTy5ru/ivogIXc=
X-Received: by 2002:a9d:da2:: with SMTP id 31mr4737846ots.319.1579236246676;
 Thu, 16 Jan 2020 20:44:06 -0800 (PST)
MIME-Version: 1.0
References: <20200116213625.GA9294@embeddedor.com>
In-Reply-To: <20200116213625.GA9294@embeddedor.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 16 Jan 2020 20:43:55 -0800
Message-ID: <CAM_iQpXi6JAOK7bWMazvOEwa=S4U3=5L5cqwKST9FKFfr+GkzQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: sched: cls_u32: Use flexible-array member
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 1:36 PM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
> Old code in the kernel uses 1-byte and 0-byte arrays to indicate the
> presence of a "variable length array":
>
> struct something {
>     int length;
>     u8 data[1];
> };
>
> struct something *instance;
>
> instance = kmalloc(sizeof(*instance) + size, GFP_KERNEL);
> instance->length = size;
> memcpy(instance->data, source, size);

Hmm, your patch is not correct, for u32 it is length+1, so you have
to allocate size+1 after you switch to zero-length array.

Take a look at u32_walk() if you have any doubt.

Thanks.
