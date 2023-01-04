Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3699B65D794
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 16:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbjADPwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 10:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235235AbjADPwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 10:52:50 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F003C388
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 07:52:49 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id bs20so31332444wrb.3
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 07:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j7qQ8dWribkTapYzoAZFdp9yAFJiQW9f4naN0OZZGi4=;
        b=ZKhwlpVOTo73pAo0wdMM0xLsmC1boVTq/oeIUPCP6SSoTvbibJ4tOq41/02g2wqToO
         fXpXzxCVw6DU4tdND9VPUbLXNFHUjl7EDJLxy+CHyHYnUmaYoadxL+6IF69eHjWWKj8x
         ascwKUZdWN1f4AWLVzSa7kh8coit2pGYOWmocGUw+tMF78b9H4+EL2PK3q8WfGDRhrS1
         2P2UaS42fAFyXXamT/UJC6kT9x19Q41ASTXo78TM6FfopLMUr74NfZoUM4uL2TSMnPGj
         KBWSV07VV9U3HabUycaKY9jNdGEmXMrRH+AoJzrM3Zz+JEymrRbOQGnA6wa2d0DWCoAY
         clwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j7qQ8dWribkTapYzoAZFdp9yAFJiQW9f4naN0OZZGi4=;
        b=mb92FKoDsAlDLey/cHlY0jxzJM7RAxzIiAwVkQYbPoOBBLLkpA8JumfQHPd0fPGX42
         QoQmpscpOtYpofrMdxhHuKs1CWefOX00oJFvF47PU3pLeQ7Tak9mZyz5R1BMzJ4TyiOu
         vAy8xDiSSSGSFw1vHgQysDKeWHPEAb44LibVpibfRsra10BskTuqDh7zd1+ZE9Gob3/h
         /x+cN5ZLzjUlg7LRUqQXH04Z45zpoO2LPxJrb/P09Lk3mi/whYpHPpvuCdWXKl0IHkNu
         B80kc7NX9HxUXVFjfIgN+D/sPbVfsMV/XzB+yV7RV/+Mp2R+cnzbyUNSBxJq0dRBVp7Y
         AlGg==
X-Gm-Message-State: AFqh2kqqiJxpnYbZQGmTxcotmYt+LO3Du6oS5nELvskwD2RKHNmnE/Fs
        FROFIJPSJ/gQVoV44mj6KxgREBXS9KMX8tVeIsA=
X-Google-Smtp-Source: AMrXdXvmGIlLgmxh5PwxGDyh4QWGgBo1FBvNJI1gjS2Tslh6/Udidl60JuO5sed67CJiI+fEdqAPkA==
X-Received: by 2002:a5d:5887:0:b0:292:f57f:366f with SMTP id n7-20020a5d5887000000b00292f57f366fmr13866253wrf.18.1672847567707;
        Wed, 04 Jan 2023 07:52:47 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id bo19-20020a056000069300b00294176c2c01sm12484556wrb.86.2023.01.04.07.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 07:52:46 -0800 (PST)
Date:   Wed, 4 Jan 2023 16:52:45 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 12/14] devlink: uniformly take the devlink
 instance lock in the dump loop
Message-ID: <Y7WgzeJh54U9VGPu@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
 <20230104041636.226398-13-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104041636.226398-13-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 04, 2023 at 05:16:34AM CET, kuba@kernel.org wrote:
>Move the lock taking out of devlink_nl_cmd_region_get_devlink_dumpit().
>This way all dumps will take the instance lock in the main iteration
>loop directly, making refactoring and reading the code easier.
>
>Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
