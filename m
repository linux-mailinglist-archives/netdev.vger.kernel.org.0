Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9DE5391F0
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 15:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240021AbiEaNkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 09:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237894AbiEaNkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 09:40:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D15D49F85
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 06:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654004445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bsu6CP/GUOJUsH16YewBdmD3L2Z38Cudgl9S5bDqmik=;
        b=YTSQYuQHl9fOiPzWVE7YV7dA1N+KHL6CN8oDVr/lf0xxtnkWF5+O7NVij6ok285TuejQ6+
        8Qf8elPGwVYBgW4WtUqls1C9YL/oRYVjgMM+wk28/FbZiVsc+2kdmHNzALjj6iLSeCYOAJ
        UZdnwf+iFgIYka8Il2jqn3Vvg1W+WLs=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-3ROBLu-jP9uD783a6hAwhw-1; Tue, 31 May 2022 09:40:43 -0400
X-MC-Unique: 3ROBLu-jP9uD783a6hAwhw-1
Received: by mail-qk1-f197.google.com with SMTP id c16-20020ae9e210000000b006a32c6a3830so10532834qkc.12
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 06:40:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bsu6CP/GUOJUsH16YewBdmD3L2Z38Cudgl9S5bDqmik=;
        b=mTiqnhKtkPQ7YRWjJVMUeTpgjs1SmFYHrdH7necX6iVCSA0CPi6ni47fud34pHn0vh
         hE0vkQGL8Dg9laCwep5E0hMU17PSF2cF4lYh+ju0xsVbyqFug++V/C49XC4PaiMl3TQq
         flwgkW5BQXI6pPl6ypWLim+5Tfes/YXnkJVuXz4dRHJvYAz9GV8Zlp1ML/63A1S0il4d
         falCG4Ou5X2+u7qiB/9tnD0xi7n5PklwdtiFeSz0upJBLVOIGX4oupu0HofkQkre+RnG
         afZ8CIOufC/bilMN388H2DgQaLabEBQ7XxHhO9pcP61UwRbVbNINwaM1yDkuIVACK2qz
         Gwkw==
X-Gm-Message-State: AOAM533xWrgEmY7ywr+4pMjMYTH2qmJXehMB9wo1W6RzqZI0XpsO5rZ1
        TP5FwKyE7OpSYfoCIh4L0fC/6FBqXd1y1ulPAsFCHDcug9zohhb7jMjaRAfpgjNuhzi8ceTfvZ9
        hk7yCSTx3Um2SgLqT
X-Received: by 2002:ac8:5742:0:b0:2fe:bb32:5e84 with SMTP id 2-20020ac85742000000b002febb325e84mr13912696qtx.249.1654004443289;
        Tue, 31 May 2022 06:40:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwkjZIr0tPd9Ohbyx+5Ll0c7YjTkOLQZRB/9UTA3rUmV4OVERjf+FgsuBg/SOQfJIu9hOlAFQ==
X-Received: by 2002:ac8:5742:0:b0:2fe:bb32:5e84 with SMTP id 2-20020ac85742000000b002febb325e84mr13912675qtx.249.1654004443085;
        Tue, 31 May 2022 06:40:43 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id b21-20020ac87fd5000000b002f917d2d3cbsm9792475qtk.76.2022.05.31.06.40.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 06:40:42 -0700 (PDT)
Message-ID: <5e628533-875e-0889-0331-1898aa868835@redhat.com>
Date:   Tue, 31 May 2022 09:40:40 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCHv2 net] bonding: guard ns_targets by CONFIG_IPV6
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220531063727.224043-1-liuhangbin@gmail.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <20220531063727.224043-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/31/22 02:37, Hangbin Liu wrote:
> Guard ns_targets in struct bond_params by CONFIG_IPV6, which could save
> 256 bytes if IPv6 not configed. Also add this protection for function
> bond_is_ip6_target_ok() and bond_get_targets_ip6().
> 
> Remove the IS_ENABLED() check for bond_opts[] as this will make
> BOND_OPT_NS_TARGETS uninitialized if CONFIG_IPV6 not enabled. Add
> a dummy bond_option_ns_ip6_targets_set() for this situation.
> 
> Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Jonathan Toppins <jtoppins@redhat.com>

