Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B79E1E577
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 01:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfENXMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 19:12:30 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:32954 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfENXM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 19:12:29 -0400
Received: by mail-qt1-f193.google.com with SMTP id m32so1183681qtf.0
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 16:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=qwfVSoUFHa8Rn5eUy3cOUVtpFRfHSRogOsbxIdQ0ERA=;
        b=X16+d55xMtxuVlx/9WFAojQlFVjTDZUiGJIb/Ec5AIJ1ybrFBJcqE12rUZiU1kk/Gd
         PPTEyBTYZzfvWJpLmHRok6jPZKtobVI41MErBPzDcw/h4XzNR/MQDMq7oonxf1PVft8y
         9G2S8t2DzLztHOpr4rGSpOxZfCCLsyWqHih2iKFY/RYoFjAmqy8nADtJfmXyZTDQUG2J
         uVefdfMf1SpgVmu5cZgWYSmXeILqxh6K/bnoX4cshSvWjDbTqplt2kGfZ4NBTTBotlNA
         usTcYtDprPElTNB9fJlGtjbR/Y5x/FMiSBRZPY8TvUU4bOPzLHn225jQrJWwieX+rhU8
         fm7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=qwfVSoUFHa8Rn5eUy3cOUVtpFRfHSRogOsbxIdQ0ERA=;
        b=UkoR2IWfRGWU5orUsVsgFyZ2TtmqYh3Zflf2OWsOHenoCFyAdM07Fgr5+IVDeleCYv
         IkXmLflt7K5OU0s/Xf0+hsnVYckD1VNZddQqluxlHorssFAFlEwU0xnhNYV1lLf7Jizi
         rxKaTn3QkEelzpKDkS2MxWBMjTZjHG0eeXx7/5XKfDAcswvRVONZeK7+I4yMzEdG5Ph0
         1nK+opTE/BLB1nRMc7eBy/dFJV9sW81YmDWfvXEYpO/Al9JS3k/V/dga5CMjjvt4UQ+N
         jy/FXw1Fzj56huW+9ev0LzfaBa91aXlO2yvYdienyi6wAuB3XHjgnkPoSW3FnlV71X4E
         Ww6w==
X-Gm-Message-State: APjAAAWygoLlsMQxL8I+m7q0oWoByGJIVNdGtY6NFXZKhT6Fbf2vCvTT
        7jNBGpYkBX2jxjGDYFkeH5Q0jmcLk1U=
X-Google-Smtp-Source: APXvYqzSvCRy1xLPAa1S4syO7RFTQ5S5Kglv6gCohNsA6RQsgSppQsAxgZm4TpPkRY2s+xhfNNcEIw==
X-Received: by 2002:a0c:9350:: with SMTP id e16mr28618880qve.119.1557875548976;
        Tue, 14 May 2019 16:12:28 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 22sm137947qkl.4.2019.05.14.16.12.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 14 May 2019 16:12:28 -0700 (PDT)
Date:   Tue, 14 May 2019 16:12:08 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        pieter.jansenvanvuuren@netronome.com, john.hurley@netronome.com
Subject: Re: [PATCH net] nfp: flower: add rcu locks when accessing netdev
 for tunnels
Message-ID: <20190514161208.302791de@cakuba.netronome.com>
In-Reply-To: <20190514.160339.393345500614325.davem@davemloft.net>
References: <20190514212819.7789-1-jakub.kicinski@netronome.com>
        <20190514.160339.393345500614325.davem@davemloft.net>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 May 2019 16:03:39 -0700 (PDT), David Miller wrote:
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Date: Tue, 14 May 2019 14:28:19 -0700
> 
> > From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
> > 
> > Add rcu locks when accessing netdev when processing route request
> > and tunnel keep alive messages received from hardware.
> > 
> > Fixes: 8e6a9046b66a ("nfp: flower vxlan neighbour offload")
> > Fixes: 856f5b135758 ("nfp: flower vxlan neighbour keep-alive")
> > Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
> > Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > Reviewed-by: John Hurley <john.hurley@netronome.com>  
> 
> Applied and queued up for -stable.

Thank you, FWIW for stable there may be a slight conflict because the
nfp_app_dev_get() call was recently renamed from nfp_app_repr_get().
