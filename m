Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8533211E3AD
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 13:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfLMMkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 07:40:42 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38159 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbfLMMkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 07:40:42 -0500
Received: by mail-wr1-f68.google.com with SMTP id y17so6496677wrh.5;
        Fri, 13 Dec 2019 04:40:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tnh80OpaBpAPAA0LDAF7S493hMNGvT3IEVpFXhg8d8E=;
        b=IEkMUBm6zzrj7BIZePfssczmAoUqzg+XdF0Byvg7pW7TnBxJmijtmrjJwjCJnW3u65
         AyUTJMJr6iR/R8Vn2HbkLZbUgmKBQJ1+w4LY7Bg7Bx9HwsR7xeUkEm/FKD9FNiTETAPK
         4ajBgYtM957KGazR4h0n4u7A2PqGpzLYK2Yp1okHMMQI2tvJtTjpzrLbEm24cMEMeZph
         6rKGrrMgNricSbhqDCwKc6GBRs8w5efApWZQsFomR0F1BXH9ryohDfJPoHdTj3PnWKHG
         AA4cwJnJOD+wk0gQVTt4AQ/ZNdQOgkU0rLKuqnd4/eo9z9Q+6r8dKCLEE2aMdrBinf4m
         Dvlw==
X-Gm-Message-State: APjAAAUrlt4eHU9+etsaHRNUCqX4+BZg5f3BbWz6iig+SinrS7hoKF03
        QWzBfjAiUHwbyYerd+Oguv0=
X-Google-Smtp-Source: APXvYqxGnKqDe80rGqRSnKDtZ9/OP25Vf+wmrPyjJ8wfJyVhyLZRXelm+SlmqF6GkeeQy/E9floipQ==
X-Received: by 2002:a5d:65c5:: with SMTP id e5mr12504298wrw.311.1576240839781;
        Fri, 13 Dec 2019 04:40:39 -0800 (PST)
Received: from Omicron ([185.64.192.240])
        by smtp.gmail.com with ESMTPSA id x6sm10385584wmi.44.2019.12.13.04.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 04:40:39 -0800 (PST)
Date:   Fri, 13 Dec 2019 13:40:38 +0100
From:   Paul Chaignon <paul.chaignon@orange.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     bpf@vger.kernel.org, Quentin Monnet <quentin.monnet@netronome.com>,
        paul.chaignon@gmail.com, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next 2/3] bpftool: match programs by name
Message-ID: <20191213124038.GB6538@Omicron>
References: <cover.1575991886.git.paul.chaignon@orange.com>
 <1e3ede4f901a36af342e71bc4fdd2b27fbf9a418.1575991886.git.paul.chaignon@orange.com>
 <20191210124101.6d5be2dd@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210124101.6d5be2dd@cakuba.netronome.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 01:04:13PM -0800, Jakub Kicinski wrote:
> On Tue, 10 Dec 2019 17:06:42 +0100, Paul Chaignon wrote:
> > When working with frequently modified BPF programs, both the ID and the
> > tag may change.  bpftool currently doesn't provide a "stable" way to match
> > such programs.
> > 
> > This patch implements lookup by name for programs.  The show and dump
> > commands will return all programs with the given name, whereas other
> > commands will error out if several programs have the same name.
> > 
> > Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
> 
> > @@ -164,7 +165,7 @@ prog_parse_fds(int *argc, char ***argv, int *fds)
> >  		}
> >  		return 1;
> >  	} else if (is_prefix(**argv, "tag")) {
> > -		unsigned char tag[BPF_TAG_SIZE];
> > +		char tag[BPF_TAG_SIZE];
> 
> Perhaps better to change the argument to prog_fd_by_nametag() to void *?
> 
> >  
> >  		NEXT_ARGP();
> >  
> > @@ -176,7 +177,20 @@ prog_parse_fds(int *argc, char ***argv, int *fds)
> >  		}
> >  		NEXT_ARGP();
> >  
> > -		return prog_fd_by_tag(tag, fds);
> > +		return prog_fd_by_nametag(tag, fds, true);
> > +	} else if (is_prefix(**argv, "name")) {
> > +		char *name;
> > +
> > +		NEXT_ARGP();
> > +
> > +		name = **argv;
> > +		if (strlen(name) > BPF_OBJ_NAME_LEN - 1) {
> 
> Is this needed? strncmp will simply never match, is it preferred to
> hard error?

I tried to follow the fail-early pattern of lookups by tag above.  I do
like that there's a different error message for a longer than expected
name.  Since libbpf silently truncates names, typing a longer name is
not uncommon.

[...]

Paul
