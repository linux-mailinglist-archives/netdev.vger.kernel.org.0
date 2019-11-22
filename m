Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E18D107A0E
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 22:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfKVVoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 16:44:11 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43015 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKVVoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 16:44:10 -0500
Received: by mail-qt1-f195.google.com with SMTP id q8so6856618qtr.10
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 13:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PRCrAUrSPu3YYS5Enu9NgP7s3PBqtnKKvUGMARE5yMg=;
        b=Yn2bNK8Ah1PBGAwnJtlCNkpBRLXVEFO+TCX04GpKoVrPxrTthh2icjcmx60pnUaKws
         2b0fOCrBo+LSs4wPXHrySDwH/6AtD+U5Vh78fd8XrZ6kWPoLkCiaGIeIAPXF8uMNwRZP
         ts4rD+9IauiwQoa5rZzV2U2x7kqejJj9K4oqk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PRCrAUrSPu3YYS5Enu9NgP7s3PBqtnKKvUGMARE5yMg=;
        b=j1sy4odOFqbCtlpZkbsgwVS9RmZWvgNiPrtFQKRUYBBZMk8fDugKbdw+ODYXntxbRr
         K14pC80s8DN+sSgwcqT+vBqIy7cC0P8PPlmJhkmaTTAOWH4cN26G87j2hIIf2xs6jbjh
         gjWbkgc0LxOuuWQlJFLipI5zSvjPIFyWJKlj2o8FhbWuEgHTy/+fHYvqzs5+4U9ttZbA
         XSE+DAlL3ngHEZUnEAdo2M6Sg3lewbI4AYkJNAee/c5QD/nvveVjmRdoAy1MhaVaZ4Vz
         JikYt/gRPN928tqKZd1YxyKtgA/Dg3327p29LgBgxtN7JVkJffwyRLnSWus0GVFFSBW6
         AqPw==
X-Gm-Message-State: APjAAAW4s/GTxjhh/vcFiPsfQl/yXxu3UuUZAdJbjBBBAsnqYw202hg6
        jqaQGq8BXpICIi+wyM9ptS9zytaQKrvjsg==
X-Google-Smtp-Source: APXvYqwJjWXV1XP6GcHVD5HWtPZm8Ga/TTsp4rkcAmfLb4YNdXceY5LOJhm9LOEfeI9C599MW4s5Xw==
X-Received: by 2002:ac8:104:: with SMTP id e4mr2348283qtg.37.1574459048196;
        Fri, 22 Nov 2019 13:44:08 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:b0cf:5043:5811:efe3])
        by smtp.gmail.com with ESMTPSA id q1sm4231414qti.46.2019.11.22.13.44.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2019 13:44:07 -0800 (PST)
Subject: Re: [PATCH net-next 1/4] sfc: change ARFS expiry mechanism
To:     Edward Cree <ecree@solarflare.com>,
        linux-net-drivers@solarflare.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <a41f9c29-db34-a2e4-1abd-bfe1a33b442e@solarflare.com>
 <921437ed-3799-acb5-c451-9cdd5385c219@solarflare.com>
From:   David Ahern <dahern@digitalocean.com>
Message-ID: <1574556c-a4c6-2316-fd0e-41d5e6b40f29@digitalocean.com>
Date:   Fri, 22 Nov 2019 14:44:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <921437ed-3799-acb5-c451-9cdd5385c219@solarflare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/19 10:57 AM, Edward Cree wrote:
> The old rfs_filters_added method for determining the quota could potentially
>  allow the NIC to become filled with old filters, which never get tested for
>  expiry.  Instead, explicitly make expiry check work depend on the number of
>  filters installed, and don't count checking slots without filters in as
>  doing work.  This guarantees that each filter will be checked for expiry at
>  least once every thirty seconds (assuming the channel to which it belongs is
>  NAPI polling actively) regardless of fill level.
> 
> Signed-off-by: Edward Cree <ecree@solarflare.com>
> ---
>  drivers/net/ethernet/sfc/efx.c        |  8 +++--
>  drivers/net/ethernet/sfc/efx.h        |  9 +++---
>  drivers/net/ethernet/sfc/net_driver.h | 14 ++++----
>  drivers/net/ethernet/sfc/rx.c         | 46 ++++++++++++++++-----------
>  4 files changed, 45 insertions(+), 32 deletions(-)
> 

Tested-By: David Ahern <dahern@digitalocean.com>


