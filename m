Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F5A3D959F
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 20:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhG1S5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 14:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbhG1S5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 14:57:18 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136E8C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 11:57:17 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso5462639pjf.4
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 11:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=127Od1Z5L5mrPERJlQTktPz34XXJuvOrvHqT3KKh12Q=;
        b=CT/CUy6V11s/6KhYMzSsdsMDErLudpJAHUqNC0Rpu9F7Ero2CNsiQemV80Kh7YxA18
         O09bddDAkQD5N79FTWd2JhufucZWJdvUnGQK4C3MDdI6o+fliBhy2PpoYHcWAEFN4pot
         mlS6O/Te+d+/T7xLqqDiIN6UOLBL2XxRO5jCQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=127Od1Z5L5mrPERJlQTktPz34XXJuvOrvHqT3KKh12Q=;
        b=cCpXPX9u4lIqn9hD2LrPJfXzt94QyIKp1ZJdJwqnbwWVK9pBgNKtrTpzRZMa6zMr11
         YmkDXMAy64ttgEQbiOc4N/1cUEvt+ESQQNORvK/K8QKfU2/Qpxav6CGTqabxgCPOzSJ9
         c1LHA7dl29fkPHCiXIaic32EFgC/YNPA6QjYNd84NO0+ggUZVygg2ZoY+BcPWVorS06S
         UDWp1newZZPFlkXMVCMSH3uCR0EdBkkFzLRLatssUNspubDBSIA08xzaorZwHKmb6Qot
         ZgYfmouGxtM3a5fL3ywGH6EMJc2IFUC2Os4mbw8MXrCB77ie6HYvFFHsGOmgd0zH+CK+
         UdjA==
X-Gm-Message-State: AOAM532+NCI4cxe+p69no48lEjbEFA8h/7ySmJjsbCRZd7XhNiCazEZf
        yGU8wNrycSTMuTDm+G3eqZjiyA==
X-Google-Smtp-Source: ABdhPJznHpu/gslPhcK+chR4/yRixyO0Zt/1nxlU5ZOnQ6g7gqNYFE0PSpANagAqHnwDfuJHc+ddvw==
X-Received: by 2002:a63:4c26:: with SMTP id z38mr313058pga.376.1627498636621;
        Wed, 28 Jul 2021 11:57:16 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d14sm5792859pjc.0.2021.07.28.11.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 11:57:16 -0700 (PDT)
Date:   Wed, 28 Jul 2021 11:57:15 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Brian King <brking@linux.vnet.ibm.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: Re: [PATCH 36/64] scsi: ibmvscsi: Avoid multi-field memset()
 overflow by aiming at srp
Message-ID: <202107281152.515A3BA@keescook>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-37-keescook@chromium.org>
 <yq135rzp79c.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq135rzp79c.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 09:39:39PM -0400, Martin K. Petersen wrote:
> 
> Kees,
> 
> > In preparation for FORTIFY_SOURCE performing compile-time and run-time
> > field bounds checking for memset(), avoid intentionally writing across
> > neighboring fields.
> >
> > Instead of writing beyond the end of evt_struct->iu.srp.cmd, target the
> > upper union (evt_struct->iu.srp) instead, as that's what is being wiped.
> >
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> Orthogonal to your change, it wasn't immediately obvious to me that
> SRP_MAX_IU_LEN was the correct length to use for an srp_cmd. However, I
> traversed the nested unions and it does look OK.

Yeah, I had the same fun. Maybe I should add a BUILD_BUG_ON() here to
help illustrate the relationship? I did that in a few other places where
the equalities weren't very clear.

For example, change it to:

+	BUILD_BUG_ON(sizeof(evt_struct->iu.srp) != SRP_MAX_IU_LEN);
+	memset(&evt_struct->iu.srp, 0x00, sizeof(evt_struct->iu.srp));
 	srp_cmd = &evt_struct->iu.srp.cmd;
-	memset(srp_cmd, 0x00, SRP_MAX_IU_LEN);

> 
> For good measure I copied Tyrel and Brian.
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

For the moment, I'll leave the patch as-is unless you prefer having
the BUILD_BUG_ON(). :)

Thanks!

-Kees

> 
> > ---
> >  drivers/scsi/ibmvscsi/ibmvscsi.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> > index e6a3eaaa57d9..7e8beb42d2d3 100644
> > --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> > +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> > @@ -1055,8 +1055,8 @@ static int ibmvscsi_queuecommand_lck(struct scsi_cmnd *cmnd,
> >  		return SCSI_MLQUEUE_HOST_BUSY;
> >  
> >  	/* Set up the actual SRP IU */
> > +	memset(&evt_struct->iu.srp, 0x00, SRP_MAX_IU_LEN);
> >  	srp_cmd = &evt_struct->iu.srp.cmd;
> > -	memset(srp_cmd, 0x00, SRP_MAX_IU_LEN);
> >  	srp_cmd->opcode = SRP_CMD;
> >  	memcpy(srp_cmd->cdb, cmnd->cmnd, sizeof(srp_cmd->cdb));
> >  	int_to_scsilun(lun, &srp_cmd->lun);
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering


-- 
Kees Cook
