Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 681646BF7B8
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 05:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjCREVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 00:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCREVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 00:21:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A114E5FC
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 21:21:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BB9D5CE01C1
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 04:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631DCC433EF;
        Sat, 18 Mar 2023 04:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679113305;
        bh=St2ZEMWKBUITLWJcCm6NzyhmFUerY8w7p/BIHom64Ms=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eNPgzmLZV2ycST01w80G7RXNOW0BQWEtqdWeEo2Gc3zzT7h931uHv6RRP0pv+2GnT
         bHk0jBuWOOogihER2zQ0v53Vqohibht7uxfKxVGIi61k48142c2gFWa/DbCfFDoM3m
         DCoy5Uxkv2P9J3uDmMm8RlrEwopiIjf5g9EMqY1yiJE0QlwCY+53zM4siX+sCLDL3z
         BERHdLcVj5XgHeB4r1eN4QRGHK8ioRE98FHh4hTMvh+Ti4QrtUGliHZ8iWfEzlrR29
         RNh5RN5QtGtMOGsxdhvImUMgdFZqJgAVpgpifS74ksBsYQzH2St9b5T9TQDMhm5I/0
         coddeEfZHtvzg==
Date:   Fri, 17 Mar 2023 21:21:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 3/4] ynl: replace print with NlError
Message-ID: <20230317212144.152380b6@kernel.org>
In-Reply-To: <20230318002340.1306356-4-sdf@google.com>
References: <20230318002340.1306356-1-sdf@google.com>
        <20230318002340.1306356-4-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Mar 2023 17:23:39 -0700 Stanislav Fomichev wrote:
> Instead of dumping the error on the stdout, make the callee and
> opportunity to decide what to do with it. This is mostly for the
> ethtool testing.

> diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
> index 21c015911803..6c1a59cef957 100644
> --- a/tools/net/ynl/lib/ynl.py
> +++ b/tools/net/ynl/lib/ynl.py
> @@ -67,6 +67,13 @@ from .nlspec import SpecFamily
>      NLMSGERR_ATTR_MISS_NEST = 6
>  
>  
> +class NlError(Exception):
> +  def __init__(self, nl_msg):
> +    self.nl_msg = nl_msg
> +
> +  def __str__(self):

Why not __repr__ ?

> +    return f"Netlink error: {os.strerror(-self.nl_msg.error)}\n{self.nl_msg}"
> +

nit: double new line here

>  class NlAttr:
>      def __init__(self, raw, offset):
>          self._len, self._type = struct.unpack("HH", raw[offset:offset + 4])
> @@ -495,9 +502,7 @@ genl_family_name_to_id = None
>                      self._decode_extack(msg, op.attr_set, nl_msg.extack)
>  
>                  if nl_msg.error:
> -                    print("Netlink error:", os.strerror(-nl_msg.error))
> -                    print(nl_msg)
> -                    return
> +                    raise NlError(nl_msg)
>                  if nl_msg.done:
>                      if nl_msg.extack:
>                          print("Netlink warning:")

