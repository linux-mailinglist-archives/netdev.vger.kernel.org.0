Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFD24D05CE
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 18:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244582AbiCGR7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 12:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244597AbiCGR7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 12:59:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BC922BD5
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 09:58:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5C94612A1
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 17:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B387CC340E9;
        Mon,  7 Mar 2022 17:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646675919;
        bh=KU/gGK7v6yQmfJ/6+NGv7XaAOm5yqYwUb1itmDn3dm0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=E3AuYANGZiu5cJBJxO7fS1yjIcpQBKvlw/cMnZetIS8L4Hx6c7kEFay23mGk7qab5
         JmEaS8OXdwbm6oaWufu7uizJxQV9UB1USL0roh8D1hF+udn3PBdkN3JNn0r7iTovlW
         Fa1YpD9piFnnVT39yAxh184RV9RXx7mubaD2Bkw72tN/wNCKBuHqPbZXLqMsEigaHs
         QtlD1dCbk1U8pE3ZiN88/Ktk5UyZWoUSycNCIUyH5rfCMhwRAduVcUZ6npPmMp4qIP
         /QDW4D/OMfcRqZ0GHuL+WvY6nd+u6PbnSs89zpM+OBCUI8iETFVptHhUFqIIS3VIy4
         +gN9lhY6CHyYg==
Message-ID: <527dab8b-6eba-da17-8cef-2614042c9688@kernel.org>
Date:   Mon, 7 Mar 2022 10:58:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH iproute2 v2 1/2] lib/fs: fix memory leak in
 get_task_name()
Content-Language: en-US
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, markzhang@nvidia.com, leonro@nvidia.com
References: <cover.1646223467.git.aclaudi@redhat.com>
 <0731f9e5b5ce95ab2da44ac74aa1f79ead9413bf.1646223467.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <0731f9e5b5ce95ab2da44ac74aa1f79ead9413bf.1646223467.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/22 5:28 AM, Andrea Claudi wrote:
> diff --git a/include/utils.h b/include/utils.h
> index b6c468e9..81294488 100644
> --- a/include/utils.h
> +++ b/include/utils.h
> @@ -307,7 +307,7 @@ char *find_cgroup2_mount(bool do_mount);
>  __u64 get_cgroup2_id(const char *path);
>  char *get_cgroup2_path(__u64 id, bool full);
>  int get_command_name(const char *pid, char *comm, size_t len);
> -char *get_task_name(pid_t pid);
> +int get_task_name(pid_t pid, char *name);
>  

changing to an API with an assumed length is not better than the current
situation. Why not just fixup the callers as needed to free the allocation?
