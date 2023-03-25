Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF546C8AA9
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 04:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjCYDdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 23:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjCYDdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 23:33:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08161CA12
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 20:33:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDCF062D3D
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 03:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E2AC433D2;
        Sat, 25 Mar 2023 03:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679715221;
        bh=oKv3a36VXlA2uh0/2XGTI60KgwysTM4X//Eo+oCn+bQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nMSiPFiFa6hMJFzA4ridD+C03ci1qVXVt3u5Y8mQ1jAaF50bUP+D/iLmEueGMIgmf
         6o83qWLli5vNnGYYGS7DjVwyceViFH4cb+oOgYDiIfwv91EUeCdDO95KyQuOrrJLor
         jh5q6IeATzwFESto5Da6aLU5csi99TbqNk8iumFyxONr4da33Xw4fBryEg49PKkLBq
         DgnUXflSp9bmPG0c6pL7k0KgaJQGno+GOJhy2oqwgk5GIxb+k8dsB8ADFmTrkk5Bgc
         plk5iGWQN5drL/PwNODEkWr1iGxhEAafHx15Md0qnd//rY1KEKvQJzzOM6yr/smjC5
         T427XBzFflesA==
Date:   Fri, 24 Mar 2023 20:33:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next v2 1/4] tools: ynl: support byte-order in cli
Message-ID: <20230324203340.712824b8@kernel.org>
In-Reply-To: <20230324225656.3999785-2-sdf@google.com>
References: <20230324225656.3999785-1-sdf@google.com>
        <20230324225656.3999785-2-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Mar 2023 15:56:53 -0700 Stanislav Fomichev wrote:
> @@ -250,7 +258,7 @@ genl_family_name_to_id = None
>                                  if entry_attr.type == Netlink.CTRL_ATTR_MCAST_GRP_NAME:
>                                      mcast_name = entry_attr.as_strz()
>                                  elif entry_attr.type == Netlink.CTRL_ATTR_MCAST_GRP_ID:
> -                                    mcast_id = entry_attr.as_u32()
> +                                    mcast_id = entry_attr.as_u32(None)

I wonder if it's worth using a default value for the argument:

	def as_u32(self, byte_order=None):

the number of Nones is very similar to number of meaningful args.
And only spec-based decoding needs the arg so new cases beyond
the 4 x2 are unlikely.

> -                decoded = attr.as_u64()
> +                decoded = attr.as_u64(attr_spec.get('byte-order'))

Could you add a field in class SpecAttr, like is_multi and read 
a field instead of the get? I'm trying to avoid raw YAML access
outside of nlspec.py classes as much as possible.
