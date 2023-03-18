Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569816BF7B9
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 05:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjCREYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 00:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCREX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 00:23:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A4518B1F
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 21:23:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BA0AB81E8A
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 04:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87179C433D2;
        Sat, 18 Mar 2023 04:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679113435;
        bh=omF+XtnAkU8MxJP1VDc/29Zw2z6POMrOJVTJsJSqWyU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nXogyrNq6cQ3nuGgJO8S6bREEdpTV5RalPF+TTua1GvnPLJNaksn+eVJO2tYLbsIY
         JRxpgbXtEd3yUkKb98WXX1qjjvJGVYdQnz+kkoBpjUK7bM2DdelYGCLjAE5AxBKimY
         kEU8mClJRFeoMamRWtD5MDM1kNAdQs8aM0ASj+aSdHwR7h2vdM2f4RuxxzGMnj0h4H
         N16IENWtKLFPImqfrtLHJFMWKQnvwm4DR5b0oPmL8EoCVXSMUrG7apkSyNEoiJJ7c5
         PbLt5MxpeCTRnxQR9u0Z/NGVG3HnE6K/LQv2mKdMZowH/5EF2sVnbPOh8PwzszGt31
         KOskvvlIYSLxg==
Date:   Fri, 17 Mar 2023 21:23:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 4/4] ynl: ethtool testing tool
Message-ID: <20230317212354.0390ced0@kernel.org>
In-Reply-To: <20230318002340.1306356-5-sdf@google.com>
References: <20230318002340.1306356-1-sdf@google.com>
        <20230318002340.1306356-5-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Mar 2023 17:23:40 -0700 Stanislav Fomichev wrote:
> diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
> index 6c1a59cef957..2562e2cd4768 100644
> --- a/tools/net/ynl/lib/ynl.py
> +++ b/tools/net/ynl/lib/ynl.py
> @@ -477,6 +477,19 @@ genl_family_name_to_id = None
>  
>                  self.handle_ntf(nl_msg, gm)
>  
> +    def operation_do_attributes(self, name):
> +      """
> +      For a given operation name, find and return a supported
> +      set of attributes (as a dict).
> +      """
> +      op = self.find_operation(name)
> +      if not op:
> +        return None
> +
> +      attrs = op['do']['request']['attributes'].copy()
> +      attrs.remove('header') # not user-provided

'header' is ethtool specific tho, right?

> +      return attrs
