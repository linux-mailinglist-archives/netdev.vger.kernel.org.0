Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA9FF16F621
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 04:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgBZDe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 22:34:56 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42456 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgBZDe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 22:34:56 -0500
Received: by mail-qt1-f194.google.com with SMTP id r5so1277831qtt.9
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 19:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aBrx1L4PaRbgYxRFTPRpkkw8Db8Ztx3HtUrIDYaE8yE=;
        b=ab4zqLmStdyDwIbyTfnBXBabRChaXj6xlYalkTFLD5HDDianeNTEMESW7nmLL0NfAL
         RJh0xh97qiaxjM81fUBb2GVuailELvk42tjiqSJyfeNEMgNHIUR5qzEr/pAoZ+80pvnO
         n7enkIEfLkvU3NNYdx+zX8LRkHqxODO42bohQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aBrx1L4PaRbgYxRFTPRpkkw8Db8Ztx3HtUrIDYaE8yE=;
        b=mon9cJ+4MBulxJBNIcp38LbwEH9GQL+owinWd2kt/FNKMWDiP5z4BG1C7RjfkHueGr
         mvESay13PQRYhfAnactGtSrsHggQnbF+0xOi4iqbnaJX3Fm05M3jIoNM9vfr7ZbmqZG7
         zthjySyaAR3Abmej//9QDOpE5osdEYKStkIQMywtKzsjA8XkKFkmgscpfRW72fs4adSo
         TjLcbTaJ+KPY7ZaVZDc0ArNqzuthOVcw9VqplG7wFig6ZUYtivoHWS+5EC+bEVNcWvCQ
         mcBEg39mi8WgYEVwDq8XG801E3Q7DisIHlwM3iLpheivppaWdw+sRkL/DILt6+zxd/D2
         8heQ==
X-Gm-Message-State: APjAAAWZYHhSXyPkCnMrhluuCjhxz5NQ2bAINeR1zmuOaV9sbqDnX857
        31j5BTf7a4fwrfUkdp5hqL8P1Q==
X-Google-Smtp-Source: APXvYqyYi//ZRUMsX3ZzkCKwIyqReeum9YvbsVLBOLmfeGYxWeG18wx4OT3h7R6dSMzes3K4G3SMnA==
X-Received: by 2002:ac8:4f43:: with SMTP id i3mr2672333qtw.186.1582688093824;
        Tue, 25 Feb 2020 19:34:53 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:e4f3:14fb:fa99:757f? ([2601:282:803:7700:e4f3:14fb:fa99:757f])
        by smtp.gmail.com with ESMTPSA id t6sm413154qke.57.2020.02.25.19.34.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 19:34:53 -0800 (PST)
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for
 using XDP
To:     Jason Wang <jasowang@redhat.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>
References: <20200226005744.1623-1-dsahern@kernel.org>
 <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com>
 <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com>
 <772b6d6f-0728-c338-b541-fcf4114a1d32@redhat.com>
From:   David Ahern <dahern@digitalocean.com>
Message-ID: <3ab884ab-f7f8-18eb-3d18-c7636c84f9b4@digitalocean.com>
Date:   Tue, 25 Feb 2020 20:34:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <772b6d6f-0728-c338-b541-fcf4114a1d32@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/25/20 8:29 PM, Jason Wang wrote:
> TAP uses spinlock for XDP_TX.

code reference? I can not find that.
