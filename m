Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B4D25F096
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 23:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgIFVO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 17:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgIFVO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 17:14:57 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015A6C061573
        for <netdev@vger.kernel.org>; Sun,  6 Sep 2020 14:14:56 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id x23so2157834wmi.3
        for <netdev@vger.kernel.org>; Sun, 06 Sep 2020 14:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Jx/2AQJ19GgF5GMqfvKOGk4UBA5cUToV3mcDGBZKY0M=;
        b=fhmW+fC2PmioUdyyeuNSunMjhlR4qJ2lZZGtlYKxTJR3KMU9Ujv6Lhc7LgQ4BBVHlG
         NyZWuH8GlRz54X0DUGci+HlYmYOQif6XyoPJPiDDZx6/suJwWtNKVNcKjnG6aNJwMrKQ
         8VavQF54Sr+nIii/kNlkV2PW2OuMxlGb3cwWc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jx/2AQJ19GgF5GMqfvKOGk4UBA5cUToV3mcDGBZKY0M=;
        b=MyZgVefq0rg5zBSMt1rNiXJkoPII6q2JMJNBNlRvWDsgOFCBrC2NmSO23Zig3gqplT
         bMxZLScoYRpruczOKq5LDct3lTig9IF4+pr1FVcXTYh6t8whLQNS1XH+Ys6XB695kjQn
         VcMKZL2iBFIr98g6C6WcruDnr0x3N+qNN5AAwDDQndr0smRCOL9rtg0gnEPfSbZ7+X2p
         uerzMgOrGNU8jLbAo2QunTIu219hrIsddniV12mbjIzqtKjIFdsGBgtukM5JdOzrJRh/
         A+IHnqSM6e36za5+HgWtgnSYwbpxP3oyQgxhZuAaBLYBOJiL+VFp+JNAh9F2zmuUAybT
         ouQw==
X-Gm-Message-State: AOAM533VtOmNhS2/yU0gT0Yl+dAM5pkPOV+TxbF5aUNkIANC3y/+HYXC
        RzdoZqsCvdTcJVyPJC4nVA+zyg==
X-Google-Smtp-Source: ABdhPJx6VgyIgp3B6hY9iDES8IcTXexiYYix88fGOdcqnAH3S7QJjVStQYozTReUd+eCBzWNryxveg==
X-Received: by 2002:a1c:3886:: with SMTP id f128mr17685983wma.121.1599426895517;
        Sun, 06 Sep 2020 14:14:55 -0700 (PDT)
Received: from [192.168.0.112] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.googlemail.com with ESMTPSA id n124sm24149928wmn.29.2020.09.06.14.14.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Sep 2020 14:14:54 -0700 (PDT)
Subject: Re: [PATCH net-next v3 06/15] net: bridge: mcast: add support for
 group query retransmit
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net
References: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
 <20200905082410.2230253-7-nikolay@cumulusnetworks.com>
 <20200906140136.77ae178d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <4f8ec4f0-6311-3b18-c7c4-a3a49b8d94b4@cumulusnetworks.com>
Date:   Mon, 7 Sep 2020 00:14:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200906140136.77ae178d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/20 12:01 AM, Jakub Kicinski wrote:
> On Sat,  5 Sep 2020 11:24:01 +0300 Nikolay Aleksandrov wrote:
>> We need to be able to retransmit group-specific and group-and-source
>> specific queries. The new timer takes care of those.
> 
> What guarantees that timer will not use pg after free? Do timer
> callbacks hold the RCU read lock?
> 

See the last patch, it guarantees no entry timer will be used when it's freed.
