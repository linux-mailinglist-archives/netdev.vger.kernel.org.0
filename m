Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6101358ED0
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 22:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbhDHUzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 16:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbhDHUzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 16:55:20 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5D7C061760;
        Thu,  8 Apr 2021 13:55:08 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id h20so1675647plr.4;
        Thu, 08 Apr 2021 13:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PWneeuBaiQGjPHMJZLrKy7/7VND3tsllGzYgluqpyqg=;
        b=pcRLaVhR2q4sT8KJWWOo+kw8Jx777AiLxWIehUYHAy6VY9Ow+LlpzYnffPx8IbVwEU
         wAzkkl7hk6JQYX8WeSUHtlqqxzVdjWXM1nN6jie9O58MZbHEZO7MAzlvzTemfgMuuj3X
         8eCFBcumm75EKXjXmVw2bEPiesJozccOXGKjfxFa4SW7/IhaABChN0Nuaqu2SlHI0Crq
         3pldPz2YMkX8+afYH4ctuKAzFb7oRact/TgxJ6TtBbTJhZccy3RYwXpmZfPB+r6dZ72W
         Xg2j68taLkNiWDnE+p3T7O4xoEpw7kEr9B3ok1JvowB+95kSYJL2YCal/qn+fbiEE4e5
         PIFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PWneeuBaiQGjPHMJZLrKy7/7VND3tsllGzYgluqpyqg=;
        b=kf0f94MkXP2Q9GZW6E6uG/JDGMfnIydpDjtKWvZD+LqKVCvwUyjvQB9XkWFK3+Mtkd
         HeMxs+UOEnecgc7PD0G5kXALHhWeWQh2zvxwqIRygfTW3oL0Om67NxxQ/QuBd8cLg51U
         klkV768JA+DYpLJSBLwOLFCZGyCHjlzTdebHOstYqaTH6hEd17svwTtPsLDwTM0B+I2J
         DgOy5We7vsPuK1suUcN2rl5OIKuhKQIw6Md6Y0D3tELEqMZ0ep7V7qNK5wVLyYRE5RLe
         Qb3xChhOkThsprENKwSFiVATAqdpK5CXAAhULhwny8geYMOtInuH5UjztozrrxdcVPl+
         4NSQ==
X-Gm-Message-State: AOAM5332JU3OAA186i4lKCv2LuBQyPfUUH23E57iyseQw0ZFGOT7AptA
        7VEpKYJ8Ak6oyAS+MseRDHs=
X-Google-Smtp-Source: ABdhPJxGpXbx75CLVPDTGbxzo1rfaanG7N0zoiEYtM7+IdQo6vPx0qdmg2UkynoNOK1uA73IUXlbbg==
X-Received: by 2002:a17:902:263:b029:e7:35d8:4554 with SMTP id 90-20020a1709020263b02900e735d84554mr9533409plc.83.1617915308225;
        Thu, 08 Apr 2021 13:55:08 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id i17sm314227pfd.84.2021.04.08.13.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 13:55:07 -0700 (PDT)
Date:   Thu, 8 Apr 2021 23:54:54 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: Re: [PATCH v8 bpf-next 08/14] bpf: add multi-buff support to the
 bpf_xdp_adjust_tail() API
Message-ID: <20210408205454.hqh7nawjrtgv4vdi@skbuf>
References: <cover.1617885385.git.lorenzo@kernel.org>
 <427bd05d147a247fc30fd438be94b5d51845b05f.1617885385.git.lorenzo@kernel.org>
 <20210408191547.zlriol6gm2tdhhxi@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408191547.zlriol6gm2tdhhxi@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 10:15:47PM +0300, Vladimir Oltean wrote:
> > +		if (unlikely(offset > ((int)(xdp->data_end - xdp->data) +
> > +				       xdp_sinfo->data_length -
> > +				       ETH_HLEN)))
> 
> Also: should we have some sort of helper for calculating the total
> length of an xdp_frame (head + frags)? Maybe it's just me, but I find it
> slightly confusing that xdp_sinfo->data_length does not account for
> everything.

I see now that xdp_buff :: frame_length is added in patch 10. It is a
bit strange to not use it wherever you can? Could patch 10 be moved
before patch 8?
