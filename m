Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CABDB4DBAF7
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 00:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244330AbiCPXZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 19:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239181AbiCPXZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 19:25:49 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F36A63AD;
        Wed, 16 Mar 2022 16:24:35 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d18so3045563plr.6;
        Wed, 16 Mar 2022 16:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G+B8PYofFQmB5bQg2/zmTVhP0vn5BLMq4NTw0OI7YZ4=;
        b=gNWxk6ELs485vb6iIjGlrEQUnqNt8dKzPs07QEUsL9LqGK5jU3xRo9hyoNQFgyji8E
         r/1dHlWf5bu1t2mfl5eemQjOpRsuxhZ0Wvok/xP9J7dq3LDg0Tv+L8xnY+QSpHPsjJUf
         XDw59AziiyL0ixjIq7cZNlXxBWTb1/SIkJ38PC0dJ8iPjQOxhfiBV3eM6V65hwA+Scr1
         GnUdhCt3uQSKUwwcjCdSevizpfCyKLrJ8kAiNL5UymtOb8mEJVh/iScqBTJarVwkvwLL
         kAHEkMxHYLRPsKJwbRXgftraEmGuS1YUjI1MvS4pPA3Kb+C2lF78cd1CoRVZb7QZ1qQi
         5IzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G+B8PYofFQmB5bQg2/zmTVhP0vn5BLMq4NTw0OI7YZ4=;
        b=amj6/TDSvzX9+oJLW9TUdtcGgKxu1rxey4XT7JeZld/I0FF4wdTOw2Af7Sx/mW/wlH
         oKbgts6BenVF76OImWDueQl/hgEazw4gBLodfglStzJEn9uyzeqBlSZ2b+z/TEwq7Jgt
         NkIBPTRWQCbPBPfmcVq42DwJqpBZRzwjoMIPDOtkvgb/rnvkVwlJVSxCuIcuaIAt8TRy
         F1LY8j7kZbbhTZh5ArHm+o4xjrct5enIx1nOBcJ/zg981dRTrHWvZ3vRgWKWQp+QLK8U
         0nnvFGpeQKDNJqcFxjKM9KTtlzREifvpLIAGLKsMS2gzGpfBGw3ZtHAu5rQ/+f0Qw1p3
         wS6w==
X-Gm-Message-State: AOAM533KliiAHvrECmOX9fkmjp0FK9bTWvQG7D+pWoS8GifvgaVuRd0m
        Lw0tGCYMO/NViLVl4GhJpl5zV+TdWjY=
X-Google-Smtp-Source: ABdhPJzrWTgL6poswUS7VkyKDbqCzmVKQnT3yHXN8WdQInlLsPcUiqBIQX3LmjNfGb+1A6eba8/pFg==
X-Received: by 2002:a17:90a:4214:b0:1bf:6ae9:f62a with SMTP id o20-20020a17090a421400b001bf6ae9f62amr12641462pjg.64.1647473074117;
        Wed, 16 Mar 2022 16:24:34 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ij17-20020a17090af81100b001c67c964d93sm639714pjb.2.2022.03.16.16.24.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 16:24:33 -0700 (PDT)
Subject: Re: [PATCH v2 net-next] net: dsa: Never offload FDB entries on
 standalone ports
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220315233033.1468071-1-tobias@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3799afd4-438c-5a63-c2d2-c95aafd0326c@gmail.com>
Date:   Wed, 16 Mar 2022 16:24:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220315233033.1468071-1-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/22 4:30 PM, Tobias Waldekranz wrote:
> If a port joins a bridge that it can't offload, it will fallback to
> standalone mode and software bridging. In this case, we never want to
> offload any FDB entries to hardware either.
> 
> Previously, for host addresses, we would eventually end up in
> dsa_port_bridge_host_fdb_add, which would unconditionally dereference
> dp->bridge and cause a segfault.
> 
> Fixes: c26933639b54 ("net: dsa: request drivers to perform FDB isolation")
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
