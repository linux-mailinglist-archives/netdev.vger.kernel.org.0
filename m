Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A064D0808
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 20:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245219AbiCGT6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 14:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245220AbiCGT6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 14:58:24 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C985C16
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 11:57:29 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id f8so4779029pfj.5
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 11:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yPy3WGIpfXIw4vF/Gbdz78c9L/bc3DyXNWdegW9XTp8=;
        b=kIzRWfsV8/CGjte4CEl9AZP39qtIxTHEhe1WPwqkEeVAld6NdgemoXaHpkERKUG52S
         lR/Xf7droPJYFBjTvVCQ+M36DeCBkiHs9wHfhg9Oe7YqwTqPtHnrHUKvnJe5YQvvUhp/
         /a9HoxUDsgGG5Uz+tns94Nfsv5qQrhbyAIT2SBlT/DOO4Dd6dvr5a9AiVJRCz+WTJ78R
         XFZ7YGiKLTuR5NryA25OCJv7X92lYA6CGuJXHfvxGC+gmz//GhoyBlwaR13AqZL21f1T
         1yMK6LCBGUSsIIzcLinAHHsTeUxVyoee56MYK8VFgsvdlTq8drVuAXz4nNFmppgMC9T5
         CWvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yPy3WGIpfXIw4vF/Gbdz78c9L/bc3DyXNWdegW9XTp8=;
        b=0ESUyIdw2sVRrCDEpbWPjZJWLtZsYIvyPBHB72z66/1U6p3kUwkiM9KHmtgDc+1Xq5
         EPLHhC2B63esMvmZ0bR6UTm1HpUfHjTUXCjPa4y80n91C3DnTOXxZAPw5iDtg7Ehjmpa
         56JFMV8mAC+0K8TH0jqWh+vUw60ZC29/1NKWtDBiDhR1g61kV7+PtB4Z1uigla+n/Z/A
         beb9ec1epoEbuPoDeznQUl8Nw5zgB0Q9tG42jG2CmJ0PMWBEi5NtJdmb2D9SeJv6Q9cQ
         wmiIMVfuXvwxTqXDq0Foed4fubO0AEGD/+aXkDQM10E9y3E0URmVouvxpEltifMNcGye
         DtRw==
X-Gm-Message-State: AOAM530MjQjyJTN4i/CSC6lwCntaheT9PoenTYZOcmreLWKgrl+bk4k4
        WPR4Mk5sFRDk/r9eJuGsSzxnHLRmUwPfDw==
X-Google-Smtp-Source: ABdhPJzjOXaRo55Tdk46a/IXl7iRdocIN9R69q/wB9Cnj2VLngqJVDKYEmCLKWOBIam3/mL4Yi40eA==
X-Received: by 2002:a63:6b02:0:b0:37c:7391:59b1 with SMTP id g2-20020a636b02000000b0037c739159b1mr11349770pgc.123.1646683048683;
        Mon, 07 Mar 2022 11:57:28 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id lb4-20020a17090b4a4400b001b9b20eabc4sm178770pjb.5.2022.03.07.11.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 11:57:28 -0800 (PST)
Date:   Mon, 7 Mar 2022 11:57:25 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        markzhang@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH iproute2 v2 1/2] lib/fs: fix memory leak in
 get_task_name()
Message-ID: <20220307115725.48679a0a@hermes.local>
In-Reply-To: <YiZNNQB727Il+EVN@tc2>
References: <cover.1646223467.git.aclaudi@redhat.com>
        <0731f9e5b5ce95ab2da44ac74aa1f79ead9413bf.1646223467.git.aclaudi@redhat.com>
        <527dab8b-6eba-da17-8cef-2614042c9688@kernel.org>
        <YiZNNQB727Il+EVN@tc2>
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

On Mon, 7 Mar 2022 19:21:41 +0100
Andrea Claudi <aclaudi@redhat.com> wrote:

> On Mon, Mar 07, 2022 at 10:58:37AM -0700, David Ahern wrote:
> > On 3/2/22 5:28 AM, Andrea Claudi wrote:  
> > > diff --git a/include/utils.h b/include/utils.h
> > > index b6c468e9..81294488 100644
> > > --- a/include/utils.h
> > > +++ b/include/utils.h
> > > @@ -307,7 +307,7 @@ char *find_cgroup2_mount(bool do_mount);
> > >  __u64 get_cgroup2_id(const char *path);
> > >  char *get_cgroup2_path(__u64 id, bool full);
> > >  int get_command_name(const char *pid, char *comm, size_t len);
> > > -char *get_task_name(pid_t pid);
> > > +int get_task_name(pid_t pid, char *name);
> > >    
> > 
> > changing to an API with an assumed length is not better than the current
> > situation. Why not just fixup the callers as needed to free the allocation?
> >  
> 
> I actually did that on v1. After Stephen's comment about asprintf(), I
> got the idea to make get_task_name() similar to get_command_name() and
> a bit more "user-friendly", so that callers do not need a free().
> 
> If you think this is not ideal, I can post a v3 with the necessary fixes
> to the callers.
> 
> Thanks,
> Andrea
> 

My comment was purely a suggestion not a requirement.
I have just had issues with complaints from compiler about code not
checking return value from asprintf, so tend to avoid it.
