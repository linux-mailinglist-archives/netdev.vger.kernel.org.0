Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43C9A4D061E
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 19:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239563AbiCGSPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 13:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235575AbiCGSPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 13:15:52 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5927D61A0C
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 10:14:57 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id p17so14617507plo.9
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 10:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c0/CrpnS1zN9Gw5mJEkzfNBIyVxln08KjeeltvQUeJg=;
        b=YzAqQKIhvLwFYvEfLf/D5EJCnL7gtgeG7AYp6crUjEsXjrg/MUyWzQ5fyfLa5B8WwO
         N/xEzMbL7nkbANtKDX0heNXeqfeN6YXTPAUJF0R1+LMA4333MYOx4hyZm9k4Oyvoo9vf
         Qwsku/LP2UZG1WWJYSGXo+SKBog6XL3+bCSSiVcEnbizu6bEDxcwGYgOezU3hSjeSMgh
         WNO6cKA1qpkjOUy/rM2PSOJegL+VJD0E5ByW/XFpKEso6Btvr3l1gMatmHrNuBEEaFD7
         tnlTETo9sPgV0v1+DnzGc8h4uIOhq0dXm02sJQK3LA9vDNRQCJcIWDA7Q3Ay81SCFElQ
         k0XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c0/CrpnS1zN9Gw5mJEkzfNBIyVxln08KjeeltvQUeJg=;
        b=vAaUHLuYtSvfmwDfRC4Aj9N82VKSz8rLq338uFDoXbb7UGgtetDI8keW9MaCJLa3U+
         npn/Ao3fMRzIZGibW9Q5FXbaey9rcJ6C9R+rHEEO351iuRcbYBW1ebyKLpxEFGWmuPR8
         uarAVICvEMdFewOAbgmEwG+yvB7+9aLC+x8feU6gxutcNs96KBtmxYGe/zjhyzkO3Ntk
         p0Fx/mm2wtxxObi1xsnzpCdogF8xgmHFsywcaZqtCcPxhBY4K4vvWLmXD0CymIwHcKml
         Dov8upYqfzueHrAQC+vURK0U8q75go9+EUQRq3CuqbAz4/l0w0gE3ZYnBPAbmFXALfVo
         +M/w==
X-Gm-Message-State: AOAM532czGo4MiFZOJOo+7z2AyaJnyvN5xN9BaY6+6FwFnv2uKNE4ocJ
        PlfLdlfc1ruGre0rx692Qou5Rg==
X-Google-Smtp-Source: ABdhPJybrfsM9xvFTHd9lGQnBxpEmTOsK/1TpCReXjH7YKs28khm0T1GN+80W09FlQRoh1mylgMKag==
X-Received: by 2002:a17:90a:7883:b0:1bd:2372:c990 with SMTP id x3-20020a17090a788300b001bd2372c990mr192693pjk.55.1646676896841;
        Mon, 07 Mar 2022 10:14:56 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id u12-20020a17090a890c00b001b8efcf8e48sm51220pjn.14.2022.03.07.10.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 10:14:56 -0800 (PST)
Date:   Mon, 7 Mar 2022 10:14:54 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org,
        markzhang@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH iproute2 v2 1/2] lib/fs: fix memory leak in
 get_task_name()
Message-ID: <20220307101454.24c02c76@hermes.local>
In-Reply-To: <527dab8b-6eba-da17-8cef-2614042c9688@kernel.org>
References: <cover.1646223467.git.aclaudi@redhat.com>
        <0731f9e5b5ce95ab2da44ac74aa1f79ead9413bf.1646223467.git.aclaudi@redhat.com>
        <527dab8b-6eba-da17-8cef-2614042c9688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Mar 2022 10:58:37 -0700
David Ahern <dsahern@kernel.org> wrote:

> On 3/2/22 5:28 AM, Andrea Claudi wrote:
> > diff --git a/include/utils.h b/include/utils.h
> > index b6c468e9..81294488 100644
> > --- a/include/utils.h
> > +++ b/include/utils.h
> > @@ -307,7 +307,7 @@ char *find_cgroup2_mount(bool do_mount);
> >  __u64 get_cgroup2_id(const char *path);
> >  char *get_cgroup2_path(__u64 id, bool full);
> >  int get_command_name(const char *pid, char *comm, size_t len);
> > -char *get_task_name(pid_t pid);
> > +int get_task_name(pid_t pid, char *name);
> >    
> 
> changing to an API with an assumed length is not better than the current
> situation. Why not just fixup the callers as needed to free the allocation?

I wonder if iproute2 should start using GCC attribute cleanup function
(like systemd) or would this be too much of using a new thing?

Not sure if using the attribute (wrapped in macro) just hides the problem
