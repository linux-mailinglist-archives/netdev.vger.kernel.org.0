Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F368DF8854
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 07:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbfKLGA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 01:00:29 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37933 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbfKLGA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 01:00:29 -0500
Received: by mail-pf1-f195.google.com with SMTP id c13so12564221pfp.5
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 22:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=8fvQOrs+FIbEFD8P4si+BoIRG1YUsg9SpPbqnJtpVZA=;
        b=uYHkahXXKf1PNyURFfuClpOiBjbICjGajrLqDJHhGesgbYtC4cnXRfoEn2NffNYPjH
         a0eNAiGUGu0vDjw9dcre5zoTGn08zg1v7g6uKQGGzvVnW4KWAq4yyG6VDmSZXo2YXcmm
         tcqBBHHcIgivJeT7z6YClto4Y7lInq2frjFzOAlwJk3vPZxAdjSdpwjQtJnBUGPEAy9F
         R7+2kOx7KO0O6FZ1wPND19XeKqIfN8rLlG8+87oiMD2YiWIuIg2T2zzT8O6fy0urS4ic
         EsxGZx1nWF2kul+bQXNGuUU+itbhegJODf9ZEGFbPY/BltR+qvWMDHCTVgO5coKjhV1L
         gGMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=8fvQOrs+FIbEFD8P4si+BoIRG1YUsg9SpPbqnJtpVZA=;
        b=XjzJC63U/MLVs5X6egKhNoebCjpyXEzHzJ40z30SpzJkKH3ID6h6ae7YNHUr/VRs8R
         gwdqnTAk5JaYVX5k0MMHjma4RE3IqmHok6veDGymW3c4+UTSPDJEPyGqbMrSKQiI0ZQj
         Q9vkr7WWsilDye7eK/lL93hksKk+StLjLcKz7x0brrMN+AVo3mBsOMAhEdXti4iwV7Ez
         dyPIpNLhPLpw1C2U7/YICibYoM562zOeyslHb9sq0F7NhMaKBhKfc6nR83OABy5wVI/Y
         sdJk7G6bVjOyM6KHXBsBhGNuVsh+ADG6KfvXOr3hpA1nyZED59Js1SxESKe/8zgOZD3k
         0OPg==
X-Gm-Message-State: APjAAAW+kO5vb19rSevJ2k0kvAbsLEDIwcZVFtYogm9PCUTmNWPwAq7d
        /OoBgj+gm8bh0B05py146ds=
X-Google-Smtp-Source: APXvYqwxYytPW6CJvW3K6VWZs82vrEmb74hja0vWj10fHQhf6w+wHzrPbUXS2uunlshRE6mi9HaIHw==
X-Received: by 2002:a63:1b4e:: with SMTP id b14mr12997627pgm.280.1573538428617;
        Mon, 11 Nov 2019 22:00:28 -0800 (PST)
Received: from [172.26.105.13] ([2620:10d:c090:180::c0bd])
        by smtp.gmail.com with ESMTPSA id d23sm17042856pfo.140.2019.11.11.22.00.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Nov 2019 22:00:27 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jesper Dangaard Brouer" <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        kernel-team@fb.com
Subject: Re: [RFC PATCH 1/1] page_pool: do not release pool until inflight ==
 0.
Date:   Mon, 11 Nov 2019 22:00:26 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <8066DA9D-7913-4BB9-9B44-0E2D1D07B8E1@gmail.com>
In-Reply-To: <20191111124721.5a2afe91@carbon>
References: <20191111062038.2336521-1-jonathan.lemon@gmail.com>
 <20191111062038.2336521-2-jonathan.lemon@gmail.com>
 <20191111124721.5a2afe91@carbon>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11 Nov 2019, at 3:47, Jesper Dangaard Brouer wrote:

> On Sun, 10 Nov 2019 22:20:38 -0800
> Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
>> The page pool keeps track of the number of pages in flight, and
>> it isn't safe to remove the pool until all pages are returned.
>>
>> Disallow removing the pool until all pages are back, so the pool
>> is always available for page producers.
>>
>> Make the page pool responsible for its own delayed destruction
>
> I like this part, making page_pool responsible for its own delayed
> destruction.  I originally also wanted to do this, but got stuck on
> mem.id getting removed prematurely from rhashtable.  You actually
> solved this, via introducing a disconnect callback, from page_pool into
> mem_allocator_disconnect(). I like it.
>
>> instead of relying on XDP, so the page pool can be used without
>> xdp.
>
> This is a misconception, the xdp_rxq_info_reg_mem_model API does not
> imply driver is using XDP.  Yes, I know the naming is sort of wrong,
> contains "xdp". Also the xdp_mem_info name.  Ilias and I have discussed
> to rename this several times.
>
> The longer term plan is/was to use this (xdp_)mem_info as generic
> return path for SKBs, creating a more flexible memory model for
> networking.  This patch is fine and in itself does not disrupt/change
> that, but your offlist changes does.  As your offlist changes does
> imply a performance gain, I will likely accept this (and then find
> another plan for more flexible memory model for networking).

Are you referring to the patch which encodes the page pool pointer
in the page, and then sends it directly to the pool on skb free
instead of performing a mem id lookup and indirection through the
memory model?

It could be done either way.  I'm not seeing any advantages of
the additional indirection, as the pool lifetime is guaranteed.

All that is needed is:
1) A way to differentiate this page as coming from the page pool.

   The current plan of setting a bit on the skb which indicates that
   the pages should be returned via the page pool is workable, but there
   will be some pages returned which came from the system page allocator,
   and these need to be filtered out.

   There must be some type of signature the page permits filtering and
   returning non-matching pages back to the page allocator.


2) Identifying up exactly which page pool the page belongs to.

   This could be done by just placing the pool pointer on the page,
   or putting the mem info there and indirecting through the lookup.

-- 
Jonathan
