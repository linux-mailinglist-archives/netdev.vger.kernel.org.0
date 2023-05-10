Return-Path: <netdev+bounces-1503-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7696D6FE081
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:40:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DF4F28151A
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4667114AA7;
	Wed, 10 May 2023 14:39:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368A2111B9
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:39:59 +0000 (UTC)
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CEB268E;
	Wed, 10 May 2023 07:39:57 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-19288cce249so5529121fac.0;
        Wed, 10 May 2023 07:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683729597; x=1686321597;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fk9eUG3U91hgmCg1FDe/Uo4ursc9HcJP8f9e+bw6f08=;
        b=hWmtYYeyl6nRGXKgze90Q4gRzbsa+Kdn9hDEGFvIihz4xDElSdRP7BAhs7xib2OaPg
         bUj062RwMs0INiSlMhO5qb7hhff4fL5vdqAuVDlMjRQeqqk74xJUWficiKqJVIjENfQf
         79+EJYEJVVUGspDM2S2iqbpnVeHu3vNHn2eOLKgAw3kfMupRi2hLSUVXwo0fR4i2uwdT
         0QVpxw3ikPUBxmcPzYtWOOipzQJ84cb0gOAyZTT7XI8wq6jk+JxJgUtk+0CHQyY75TpF
         DfTG/9+fi7M4FCc7OdNi/xuLW9yPVwxBf2+dST2A2uu6RrY5Q7lgS74ju9Dl9d8RLIWa
         w+Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683729597; x=1686321597;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fk9eUG3U91hgmCg1FDe/Uo4ursc9HcJP8f9e+bw6f08=;
        b=eCXIEuaVT1ojSxJazh7l46lGLUTL7OR8Lk0R3HEn6oioLDiHry45dodiouN/wzzi6b
         y6TqskXZrv0OL1/WU1vuadohZ160ZOTJG8aNJLwDa7Suvlsmo5uLHYBoJnPVFebFJy/c
         aGBBozkXUCAgwTzQc1+5kICRyqtfGRaVURI/iPjL4+1qOfirnztwVkZZP5xvY85gvtLO
         MIoDPr7qtLVpuVfmNrYa81BLIMApEYcvx+aTgNgZgpuofny+DPN0DqfYatW/1N/5I5nD
         VXq81VCQivuZxnjoyW/hiQXYj5JE35Ji9hnGETUZ8oCVOI6US5ydEad5Llly4DvoYgfb
         w5xw==
X-Gm-Message-State: AC+VfDxHb6iyj1+LozXCA2WToi3zlu7/zCAiEhAWn/4i2qt+NQlCQWee
	3e+JwZF0rUlWB9yqCmnNkYs=
X-Google-Smtp-Source: ACHHUZ5pF+M++RxLzw+et8XA4BnqeGBSkMIpGL9wjTOHn5jtyuulDOVKMxiKgQKK2qIlAwKnMk2PgA==
X-Received: by 2002:a05:6870:9544:b0:192:85fb:3a33 with SMTP id v4-20020a056870954400b0019285fb3a33mr6652658oal.2.1683729597002;
        Wed, 10 May 2023 07:39:57 -0700 (PDT)
Received: from t14s.localdomain ([177.92.48.137])
        by smtp.gmail.com with ESMTPSA id n3-20020a056870034300b00176d49bb898sm6973892oaf.44.2023.05.10.07.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 07:39:56 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
	id 70AEA616D93; Wed, 10 May 2023 11:39:54 -0300 (-03)
Date: Wed, 10 May 2023 11:39:54 -0300
From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc: nhorman@tuxdriver.com, davem@davemloft.net,
	Daniel Borkmann <daniel@iogearbox.net>,
	Christian Brauner <brauner@kernel.org>,
	Stanislav Fomichev <sdf@google.com>,
	Xin Long <lucien.xin@gmail.com>, linux-sctp@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] sctp: add bpf_bypass_getsockopt proto callback
Message-ID: <ZFusunmfAaQVmBE2@t14s.localdomain>
References: <20230510131527.1244929-1-aleksandr.mikhalitsyn@canonical.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510131527.1244929-1-aleksandr.mikhalitsyn@canonical.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 03:15:27PM +0200, Alexander Mikhalitsyn wrote:
> Add bpf_bypass_getsockopt proto callback and filter out
> SCTP_SOCKOPT_PEELOFF and SCTP_SOCKOPT_PEELOFF_FLAGS socket options
> from running eBPF hook on them.
> 
> These options do fd_install(), and if BPF_CGROUP_RUN_PROG_GETSOCKOPT
> hook returns an error after success of the original handler
> sctp_getsockopt(...), userspace will receive an error from getsockopt
> syscall and will be not aware that fd was successfully installed into fdtable.
> 
> This patch was born as a result of discussion around a new SCM_PIDFD interface:
> https://lore.kernel.org/all/20230413133355.350571-3-aleksandr.mikhalitsyn@canonical.com/

I read some of the emails in there but I don't get why the fd leak is
special here. I mean, I get that it leaks, but masking the error
return like this can lead to several other problems in the application
as well.

For example, SCTP_SOCKOPT_CONNECTX3 will trigger a connect(). If it
failed, and the hook returns success, the user app will at least log a
wrong "connection successful".

If the hook can't be responsible for cleaning up before returning a
different value, then maybe we want to extend the list of sockopts in
here. AFAICT these would be the 3 most critical sockopts.


