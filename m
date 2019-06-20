Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED59B4D41B
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 18:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfFTQrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 12:47:41 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44518 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfFTQrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 12:47:40 -0400
Received: by mail-io1-f65.google.com with SMTP id s7so568197iob.11
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 09:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o/hnT29lMWp6QTRQYtQKymeDS+vV9ovN1umc06HzvYk=;
        b=srtOcl/r9aXiqa8ytoKtaZ5RL8Fxh0FcQnqlZkQ1qbb4X/AM3Pcoky77bMyoMd9ffS
         R/8dRxALs9NerquX6+YCBevy1hmi7rsPDsO057CGwRPSHAyJGARwxz0vtkgqL5gYXa+Y
         iqOqgqKYOKcfu5xphg0lG1XldEmCecF/B8yCItLtld7nRbIhqYDYuDTA4IZ3+39NqEGG
         YXSCctLS/CoiS02OR8P9VrIMqn1vx/rV4OYEdYUFo+EydMrQIxwbOsj0wMClyW7+RI+n
         tkRNTK4SIiQPAIsNqForZ+16+B/+kiheeYRu6KeNwj9N8mxZOdXBKwoRsWu1jeeYayes
         M56g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o/hnT29lMWp6QTRQYtQKymeDS+vV9ovN1umc06HzvYk=;
        b=ejSwdF5uSaoBeBuhrBR/VznWWEjuFTwRFpOPa3Wk/yWAlgsutJ2/kbntBmtiZcsUpy
         DcW0kD+p72Sed2Ia7yL/QbvtXECkxRa0pi9yrjYi0pExUrTrQQ9JUOUMF6sb3KtpcwYY
         +603omdQTObPItE7MrqUXbkuSKiaCetg6XACRkYtAAK05iet9YDjON3j+BL0O8ep1YYA
         XMlJn8e9LJLzMPFbGTPn3dZhsmJBhkWeSVH5rdtkEGir+l5M8QkrjgYQEGhrQ7O2dmQi
         75iX5Ziv/O4DmanIM6mTjggsVnlAn27y2eoS+sxFNpffDfg6xh/hdwLdxBHy5FcdwQ7t
         oPPQ==
X-Gm-Message-State: APjAAAUi7SDeh6ENdNJynZXby8K2ftVjkV3KT+kCjf4q0+HQD+t+KFst
        0Sg8vC7wP9a3r2PwW24lcjSNWe4o
X-Google-Smtp-Source: APXvYqykfP/8crkZjnW6uwvDC7xzBJQyZCywO7jzweIQDJ/hhwKC3JpmwoM9Uk/zKyt1CeCBQ88/QQ==
X-Received: by 2002:a02:a581:: with SMTP id b1mr42899873jam.84.1561049259841;
        Thu, 20 Jun 2019 09:47:39 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:9c46:f142:c937:3c50? ([2601:284:8200:5cfb:9c46:f142:c937:3c50])
        by smtp.googlemail.com with ESMTPSA id a2sm211786iod.57.2019.06.20.09.47.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 09:47:39 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: fix neighbour resolution with raw socket
To:     nicolas.dichtel@6wind.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190620123434.7219-1-nicolas.dichtel@6wind.com>
 <fb3ed305-0161-8d6a-975c-54b29cfcb0ef@gmail.com>
 <3066f846-f549-f982-7bc0-1f9bc3d87b94@6wind.com>
 <c1e3d444-a7c9-def4-9f16-37db5dd071fe@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <86a573b4-0fae-b9bb-341c-7ce78f97e888@gmail.com>
Date:   Thu, 20 Jun 2019 10:47:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <c1e3d444-a7c9-def4-9f16-37db5dd071fe@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/20/19 10:36 AM, David Ahern wrote:
> 
> Also, this does not fix the forwarding case. For the forwarding case I
> still see it trying to resolve fd00:200::fa from dut.

nevermind. I used the wrong address for the forwarding case.
