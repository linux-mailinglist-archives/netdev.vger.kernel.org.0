Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4078A808D8
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 03:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbfHDB6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 21:58:41 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34132 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfHDB6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 21:58:41 -0400
Received: by mail-pg1-f193.google.com with SMTP id n9so31699414pgc.1
        for <netdev@vger.kernel.org>; Sat, 03 Aug 2019 18:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=XseFOdxuGU418KZPE3WRhO05R0PXJPpb27YbinC92EA=;
        b=ONsYKIsZd9R81XYlXqkrM1leMaNefPuWmEV0yIkemzjsDzVo1BwNZEmJyT+GXEvlq2
         CkRjpbeSNXVjfvNqGSI3CNg0kjH37EyHBh4hPPL/BAFkFq2nS0LAo9ygg8rRGLf6Rsgc
         Hs/i9VkX+eNDCWS25fjWY/7sLJ5CM6IDIsBmyiKdJFtm3TVJJWwm9U+l43oUST9EmXxM
         LCRWnbCE+WekDtbq8gIXOv7+pzroK5SVKMl/v5Vt7vRrCLrwc2iujh0GAlLhka7jDZHl
         fTUHS9sNrsSI/5TgHbtWciNm9XR32PnNY36YdUWbyq6sITzY3nnl3GmcIIfjiNFwRWQB
         4Plg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=XseFOdxuGU418KZPE3WRhO05R0PXJPpb27YbinC92EA=;
        b=WYCSPz0NZdiP3NZCpxicu+hKOv3PbfiU8vtPCELfJcr4pIIWYvEEQKfqCYTkgclLPd
         pLqVbKPZJneKonuuDacyQU45FthxjXJm+w/iNxdY492fSPUqPWUuNjTjisjCOyPDUGip
         nhrGYMbt7VHnx0fUqV8wV5mwZLyU9g4mwzQLQAW0+aRf2Y0pZToQnsLO8Jti0J/0/1A3
         KM4GgRaymWQ78E1UUTnVXM3n/X73KZzmdzxP6b8/9lwsT8S3tZcAeBN5C33o0Gmppoge
         npsezgdsBDTznL/6hSxJqYei8CQnfh7SsK2rVkXblp8IdXmY6Knpt24QKN2HBaVPF3zC
         GUFA==
X-Gm-Message-State: APjAAAWQr8eCC7wMKuQUF6DWipB9K9vTeSKna/xg+3uj+7iMWH2kbMKP
        Rd3bkGvwIaqDLIdnY0KiR1hubA==
X-Google-Smtp-Source: APXvYqzA2RHCJOlXy2g9CxbfktX1OESzi0EVdTchdFtqBiqxNCodmspmE2sjhwarGzQhNVFPDaVm+Q==
X-Received: by 2002:aa7:8383:: with SMTP id u3mr67045320pfm.175.1564883920693;
        Sat, 03 Aug 2019 18:58:40 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id m31sm18746359pjb.6.2019.08.03.18.58.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 03 Aug 2019 18:58:40 -0700 (PDT)
Date:   Sat, 3 Aug 2019 18:58:20 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        edumazet@google.com, borisp@mellanox.com, aviadye@mellanox.com,
        davejwatson@fb.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        willemb@google.com, xiyou.wangcong@gmail.com, fw@strlen.de,
        alexei.starovoitov@gmail.com
Subject: Re: [PATCH net-next] net/tls: prevent skb_orphan() from leaking TLS
 plain text with offload
Message-ID: <20190803185820.3beb3d2c@cakuba.netronome.com>
In-Reply-To: <20190802.172453.1075167824005057182.davem@davemloft.net>
References: <20190730211258.13748-1-jakub.kicinski@netronome.com>
        <20190802.172453.1075167824005057182.davem@davemloft.net>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 02 Aug 2019 17:24:53 -0700 (PDT), David Miller wrote:
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Date: Tue, 30 Jul 2019 14:12:58 -0700
> 
> > I'm sending this for net-next because of lack of confidence
> > in my own abilities. It should apply cleanly to net... :)  
> 
> It looks like there will be changes to this.

Yes, sorry for going silent, I reworked this to follow Boris'es
suggestion of using flags, and wanted a little bit of extra QA.
Unfortunately 5.3-rc has broken Intel IOMMU and QA lab machines
don't boot.. :(
