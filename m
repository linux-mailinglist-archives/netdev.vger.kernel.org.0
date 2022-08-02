Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B03587DC6
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 16:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbiHBOBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 10:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236960AbiHBOBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 10:01:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E750D1C107
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 07:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659448901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LUHv4x5a6YZb94507hyxXVCHu0MZW82loqntFPHXbN4=;
        b=ICXHTlJ1tsLH2mq9CfrCTgvYoisdUJUurBfgxH45OpWSwypSMEzqq5pG4MMIEYrUHQa0eW
        SIq5XDf9xke1+iZW/DA4DNjat9qi5cbjcAiOzqCLZg8FA9n1aQcCIA8iIAxmmNN3rkM4CZ
        gENxE0+ephFMqbmqA/WXPTNF+HJV7Yk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-213-LPxgT18nOR-lsh_asIxZIw-1; Tue, 02 Aug 2022 10:01:35 -0400
X-MC-Unique: LPxgT18nOR-lsh_asIxZIw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE4841C0512A;
        Tue,  2 Aug 2022 14:01:34 +0000 (UTC)
Received: from sparkplug.usersys.redhat.com (unknown [10.40.192.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BD895141510F;
        Tue,  2 Aug 2022 14:01:32 +0000 (UTC)
Date:   Tue, 2 Aug 2022 16:01:30 +0200
From:   Artem Savkov <asavkov@redhat.com>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>, Song Liu <song@kernel.org>,
        Daniel Xu <dxu@dxuuu.xyz>
Subject: Re: [PATCH bpf-next v2 2/3] bpf: export crash_kexec() as destructive
 kfunc
Message-ID: <YukuOj4CR3HgUv1S@sparkplug.usersys.redhat.com>
References: <20220802091030.3742334-1-asavkov@redhat.com>
 <20220802091030.3742334-3-asavkov@redhat.com>
 <YukAkjqdAqr9x2Bs@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YukAkjqdAqr9x2Bs@krava>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 02, 2022 at 12:46:42PM +0200, Jiri Olsa wrote:
> On Tue, Aug 02, 2022 at 11:10:29AM +0200, Artem Savkov wrote:
> > +static int __init crash_kfunc_init(void)
> > +{
> > +	register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &kexec_kfunc_set);
> > +	return 0;
> 
> should we do 'return register_btf_kfunc_id_set(...' in here?

Maybe, but as far as I can tell the return value for init calls does
absolutely nothing except for showing up in a debug message. So I don't
think it will be worth a respin, but if there is one anyway I'll change
this.

-- 
 Artem

