Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24ADD399E9
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 02:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730340AbfFHAWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 20:22:16 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:47068 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729685AbfFHAWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 20:22:16 -0400
Received: by mail-pl1-f195.google.com with SMTP id e5so1398068pls.13
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 17:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8U2c68J+RGnQt51A2K0YoinPAxjlIvpJH3fCz7y7OD4=;
        b=r4wqkKQBq6QXaRQurtbVn2Ctb1nHGRszkti56TybsPD3n6tCwkXFg5c6gjKT5Sag8O
         VpqQoQzUpX6U/5CO8JWWPi3o7eF7oI7RuJJ2ya+wv6yTbOBIZhdu+dxF5fTWzE4g0ahI
         CCCQ03kM76BPthejFo2c+XIqZKkHErWiAxIckZ+gZMI6mpxkx99bWeu1vHVHL0Ti81bF
         /daGo+yymDzqwaxAyrttXHAeItpq+49Qc1M+Rso9M7aQ6ditk+gh3TwXPvODKW5X5EXY
         mGiflH19lWW+qL/XCjbgQjV03QTtd/2L+jvISIC79leEycuVeE5yFhmJ17/fsp/WW17p
         S3Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8U2c68J+RGnQt51A2K0YoinPAxjlIvpJH3fCz7y7OD4=;
        b=dtGzw3YZZcvs/IqG0rmo76QzU5FbCvqVHHuidGUSqA0cFMF/4cjQ5UdEIqCQXPsUAu
         t7vSkNIiFPaq+EBDwA9Kxj1hCq727ZiU7sodoupFrt+V9Q8+FrEEMLPU/07zqEmKVfwp
         AL/fU5nNV7FftZ3PvB7JvX09rvHfGTTWiqaltRJpwT7QjUwPUti3kE8mAwmady4y4xia
         OM+B3dpH55HeF38qOAyOZLtDxFEX24cmQFw1dQpr9ZIeUnF+D+8XplC4v4n8SHm80Q59
         XSWTC9WT1/i+TR0TqU6bqZf7FhhwJZ3GUz0Kj7TlerOq6OVBzWe06ONkE66N25purmPy
         yeXA==
X-Gm-Message-State: APjAAAXAlmjQVkOBAuNg0WLIPfhcc16Tb+hEuxhPjydiUVqq3cBUahTE
        aWMvOICi0PIu/phdTfUrvA8=
X-Google-Smtp-Source: APXvYqw2uCzRtYUkC8HHPnPniNoXzmW0fS92+A6wWV8QZTn/h1qHh9whD1EzH4r5LA+qeT86DOznCw==
X-Received: by 2002:a17:902:724:: with SMTP id 33mr57369736pli.49.1559953335634;
        Fri, 07 Jun 2019 17:22:15 -0700 (PDT)
Received: from [172.27.227.254] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id y22sm3674922pfo.39.2019.06.07.17.22.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 17:22:14 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 09/20] ipv6: Handle all fib6_nh in a nexthop
 in rt6_do_redirect
To:     Wei Wang <weiwan@google.com>, David Ahern <dsahern@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        idosch@mellanox.com, Martin KaFai Lau <kafai@fb.com>,
        Stefano Brivio <sbrivio@redhat.com>
References: <20190607230610.10349-1-dsahern@kernel.org>
 <20190607230610.10349-10-dsahern@kernel.org>
 <CAEA6p_BHrHUAgF_Ca4=zRc2iH6WBOGPkLK+a3_h43zmn6uZKWA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <89620ba8-971a-f6a5-e1cf-20dc8eac1eca@gmail.com>
Date:   Fri, 7 Jun 2019 18:22:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAEA6p_BHrHUAgF_Ca4=zRc2iH6WBOGPkLK+a3_h43zmn6uZKWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/19 6:11 PM, Wei Wang wrote:
> I don't think you can directly return here. We are still holding
> rcu_read_lock() here. Probably need "goto out"...

ouch. yes, thank you for catching that.
