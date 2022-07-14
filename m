Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA385574ACB
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 12:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237359AbiGNKhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 06:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiGNKhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 06:37:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 995AD4B49F
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657795066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4aMq9d6XOL2BYD5DztJ4VTiy/FnmnCeD5N5a+nINSVM=;
        b=TfOJe27aUqpExY64HMllRYd3rLsto1wK/MSUUQjm4GQcgX3V3uDyTu0YX47UKrb1DbxhZL
        4FAgHIi6+aA/gAuEmNxgIl7o8HLeOQYgr0RvVdfCoGeMLOqXmXntqFLvCFyK9mtj7DVDdT
        vatDJfLnezvkLRzgwsvcr16cjSouN4c=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-E2xU28KxN5ewL8nAoBfQiw-1; Thu, 14 Jul 2022 06:37:45 -0400
X-MC-Unique: E2xU28KxN5ewL8nAoBfQiw-1
Received: by mail-wr1-f72.google.com with SMTP id r17-20020adfa151000000b0021d6c4743b0so453304wrr.10
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:37:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=4aMq9d6XOL2BYD5DztJ4VTiy/FnmnCeD5N5a+nINSVM=;
        b=foF73SLE2ZtSqeXZOxHNnfMbhG3cs2DN5+52rHTQ3ul49yyRsG+CZFFEZ1nhF9VvEv
         +WMTdOkbMawqWmVwDij6WgGlrM1zc63dPEOt7QiCqZBxhs7rI525XEq3dspbA616JhU8
         oVJ+NwM95A05O1z3+pobFhJEGqa75KdAns50UW/n8N1hNcoJCASpNLUWLGVbmZIxC/1F
         G2I334AmmAi6r21LauHFpUvoZHKUXgRDQkM5mGmjY9qxbbIodcVVw25VEsumzjaHDlsJ
         O44zKGV6rHxE/9ZLeGxkVGJJmUPdBAyHwugIoK7XM+8DBThmpMCA6GlGS8ILjzW/Q9bB
         dtIQ==
X-Gm-Message-State: AJIora/sBeWSgr2rnaQlJZ8m38cQeWSmwu/HY6zEGxqWEVD2vxZpDclX
        1ze33hn0YSheBRD8oY1VdQPu8gPWEJyYyJja8tz1X17C6qMzSvKRB2GfPY3I/oZNVO11Of3+b1G
        jP8sL7hnE8NIb33Aj
X-Received: by 2002:a5d:5268:0:b0:21d:6c45:fe6 with SMTP id l8-20020a5d5268000000b0021d6c450fe6mr7908390wrc.380.1657795064437;
        Thu, 14 Jul 2022 03:37:44 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tnjBGgvWE3ovLJfa/IOyiITy8LVVfr+LAvxJzgOIn3iB+Jjr4weNUd9JZmrQbt3acfbGY+ng==
X-Received: by 2002:a5d:5268:0:b0:21d:6c45:fe6 with SMTP id l8-20020a5d5268000000b0021d6c450fe6mr7908378wrc.380.1657795064245;
        Thu, 14 Jul 2022 03:37:44 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-238.dyn.eolo.it. [146.241.97.238])
        by smtp.gmail.com with ESMTPSA id y18-20020a05600c365200b003a2c67aa6c0sm1744360wmq.23.2022.07.14.03.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 03:37:43 -0700 (PDT)
Message-ID: <9582eec95583412e51484092e13d7a773c338f34.camel@redhat.com>
Subject: Re: [PATCH net-next 2/2] xen-netfront: re-order error checks in
 xennet_get_responses()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jan Beulich <jbeulich@suse.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Cc:     Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <stefano@stabellini.net>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Date:   Thu, 14 Jul 2022 12:37:42 +0200
In-Reply-To: <743b3ff3-896c-bfc9-e187-6d50da88f103@suse.com>
References: <7fca0e44-43b5-8448-3653-249d117dc084@suse.com>
         <743b3ff3-896c-bfc9-e187-6d50da88f103@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-07-13 at 11:19 +0200, Jan Beulich wrote:
> Check the retrieved grant reference first; there's no point trying to
> have xennet_move_rx_slot() move invalid data (and further defer
> recognition of the issue, likely making diagnosis yet more difficult).
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> ---
> I question the log message claiming a bad ID (which is how I read its
> wording): rx->id isn't involved in determining ref. I don't see what
> else to usefully log, though, yet making the message just "Bad rx
> response" also doesn't look very useful.

For the records, I (mis-)read that log message differently, claiming
there is a bad RX response, and specifying the ID of such response,
which may or may be not useful to diagnose where/when the problem
happens.

Cheers,

Paolo

