Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAA87E491
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732102AbfHAU6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 16:58:12 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34984 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728669AbfHAU6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 16:58:11 -0400
Received: by mail-pf1-f196.google.com with SMTP id u14so34768856pfn.2;
        Thu, 01 Aug 2019 13:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZUawhWWr8+15bzby9wofkotzfmMRu0Ab0J23wjbFd8Y=;
        b=BDc6M0lZwi3K1eu7rubLLZb3/i8zl2c91u91derpKLDr+UX7W5fpg8RrNAW06cNlgO
         J9e4NTg4gLce2M4Tqc8wj+0tgYVF/9icOIheShl0pcKK8bs/MsmAIyQdODTtgtC/373i
         Fxj4lGtgvN66ddUdBdi5lEnQWT4xXgsor6l5ACom/+j2RW2+6a/EhLhFb0BTJfZbGkpi
         HyXt9faAyqhf6LT5lYYK5jP+X4l0QpsK9+t5mhWQ5358Ou9OS4AWN4espyTzbtkBIV/v
         OGS4HBQqZo1SOqgJ00C1ifihztmHqBPEMRH/4p81myq4fyX3WA5HqC2UJ2FHeR+XBf4l
         ZV3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZUawhWWr8+15bzby9wofkotzfmMRu0Ab0J23wjbFd8Y=;
        b=P7mdxzEuoKgCtuC4W8UtV8UIM2uhGyPDaWtqWKPfV2GX59xyudhh+fc34i7wwGg0yv
         FuVT1sg/d6uq3yaXRhOgzIOX6Mw3rnZ3bAsqIs4pCR7izHhzG8tf8YW6XZNMgmMplIaS
         HcY3CJzujN0cMNiXK83GPRTfY4rLk6sO1o89+0jiWBQGISkUp0s8MMxvjr5m4PopUc6n
         JJacnJCuqn3jmZMuKPE5vDemDxzxHQk9aEPFaJMwtPddbbqO3jSaLykAWEflXpcPC6Gs
         DEtFq9dolhvqH6sKzhznQCWmxf5r65+dScKcy+ZShgZgwxNx/fm5KtlXBQyY/ibyodbD
         KApA==
X-Gm-Message-State: APjAAAWSe9NH4tvBicnBEaYtCLVePHb9CYLE8HmYUsXBn/Tr6P+5Tw59
        62dIhLa+n6pwh6TbbwbKoFc=
X-Google-Smtp-Source: APXvYqyy2cuMI/eA31QMyT2pDI1vvN/S2fOHaOn7U3aQXHzOWhpOLYGUrGrFM2v5zlt0NPLoGrXvSw==
X-Received: by 2002:a63:f304:: with SMTP id l4mr120024747pgh.66.1564693091026;
        Thu, 01 Aug 2019 13:58:11 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:f96b])
        by smtp.gmail.com with ESMTPSA id h1sm92388510pfg.55.2019.08.01.13.58.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 13:58:10 -0700 (PDT)
Date:   Thu, 1 Aug 2019 13:58:09 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net
Subject: Re: [PATCH bpf-next 0/2] bpf: allocate extra memory for setsockopt
 hook buffer
Message-ID: <20190801205807.ruqvljfzcxpdrrfu@ast-mbp.dhcp.thefacebook.com>
References: <20190729215111.209219-1-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729215111.209219-1-sdf@google.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 02:51:09PM -0700, Stanislav Fomichev wrote:
> Current setsockopt hook is limited to the size of the buffer that
> user had supplied. Since we always allocate memory and copy the value
> into kernel space, allocate just a little bit more in case BPF
> program needs to override input data with a larger value.
> 
> The canonical example is TCP_CONGESTION socket option where
> input buffer is a string and if user calls it with a short string,
> BPF program has no way of extending it.
> 
> The tests are extended with TCP_CONGESTION use case.

Applied, Thanks

Please consider integrating test_sockopt* into test_progs.

