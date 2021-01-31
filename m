Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2CC309D7A
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 16:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbhAaPYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 10:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhAaORb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 09:17:31 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73AAC061574;
        Sun, 31 Jan 2021 06:16:31 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id lw17so8305628pjb.0;
        Sun, 31 Jan 2021 06:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7bGpwFVo7xYMiRiub/f4zLcAqxS1DlusIS6u9BLoh04=;
        b=RfZVSgFYvlSLZOZgqn6+Jmo50up+5PWoBqg8zlGp+mcUYiCFGB1E9Lc+8buCHXyZL4
         KHLMreKlIw1q/YgA7diIODYh8rO8HYbEw2ko4uSOe7f9g8BdlSlo0J6Mamu9nMpL5q6F
         aQC3yIaZT53H8okppNKwZEb76bHLUhGS6sEoSMAnUk2mHzJzNLiCvjWqnBl1ZZsHdVmW
         tLWm2xFsqCjkHviCuJkJkIbGxyyjTv265vgjmrlAyjI085Vc6ySAgxagQWmOhUVmrLfK
         kvxXU+a18FWO8KfMhXMd2hG/9ACgwGvEKylYedJI6Ay7HhHmCL5sdSS3Uvl6P2rLpoj0
         JAZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7bGpwFVo7xYMiRiub/f4zLcAqxS1DlusIS6u9BLoh04=;
        b=QZK4G35zqWceH9N1c/7ta5mKCA4A8Ct/9aL3owlYlthlSEX0jUV8r5YBMFZ1dgehyE
         ZqC83cPSI+4HBxUK8ZMHo8+wAS8aPdEETuvktEP4dYwOPvsrZmgynDJ0qzD67VteHWHA
         jxGDubkr++Vnm1WYVwy+vZ4JUeVhLEEo7JIXWBLhuKUfgYzvzS8xY8vSFQKoxQSfe8te
         +QO+fd7wFVfu9NHfvCW1hdy5xsJQPV6Aa0zHyDYwWBvuWhRj4TOeFQVODizjxuByaqLP
         mVXZ317mn2PkLRrP4g3UaIVBmU4q3FR/fRBOqOMkoXsZX4qmCZGnKG5lXxx/3UVXsRYW
         j+kA==
X-Gm-Message-State: AOAM530nJEXJqyLGzSUDkmEutilF6NiQ8mH50yVrgvt/LLs+RaFXBZOB
        OJ0KTlzMLCge5ugDMPLlS1E=
X-Google-Smtp-Source: ABdhPJxwr/C+eXE3f8AXrQ5igE5EltGwySO8LWMjbQlFyEF14wSX4wFMJQJmGtsFfgd0u/zP31ESUw==
X-Received: by 2002:a17:902:fe03:b029:e1:2c46:f3fd with SMTP id g3-20020a170902fe03b02900e12c46f3fdmr8850229plj.62.1612102591241;
        Sun, 31 Jan 2021 06:16:31 -0800 (PST)
Received: from [192.168.1.18] (i121-115-229-245.s42.a013.ap.plala.or.jp. [121.115.229.245])
        by smtp.googlemail.com with ESMTPSA id gb12sm12740132pjb.51.2021.01.31.06.16.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jan 2021 06:16:29 -0800 (PST)
Subject: Re: [PATCH v3 bpf-next] net: veth: alloc skb in bulk for ndo_xdp_xmit
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, toke@redhat.com
References: <a14a30d3c06fff24e13f836c733d80efc0bd6eb5.1611957532.git.lorenzo@kernel.org>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <b63d0fb0-319a-3246-f187-4e7ad14ebc75@gmail.com>
Date:   Sun, 31 Jan 2021 23:16:24 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <a14a30d3c06fff24e13f836c733d80efc0bd6eb5.1611957532.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/01/30 7:04, Lorenzo Bianconi wrote:
> Split ndo_xdp_xmit and ndo_start_xmit use cases in veth_xdp_rcv routine
> in order to alloc skbs in bulk for XDP_PASS verdict.
> Introduce xdp_alloc_skb_bulk utility routine to alloc skb bulk list.
> The proposed approach has been tested in the following scenario:
> 
> eth (ixgbe) --> XDP_REDIRECT --> veth0 --> (remote-ns) veth1 --> XDP_PASS
> 
> XDP_REDIRECT: xdp_redirect_map bpf sample
> XDP_PASS: xdp_rxq_info bpf sample
> 
> traffic generator: pkt_gen sending udp traffic on a remote device
> 
> bpf-next master: ~3.64Mpps
> bpf-next + skb bulking allocation: ~3.79Mpps
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Reviewed-by: Toshiaki Makita <toshiaki.makita1@gmail.com>

Thanks,
Toshiaki Makita
