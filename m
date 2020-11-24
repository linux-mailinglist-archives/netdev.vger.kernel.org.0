Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDD92C303B
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 19:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404317AbgKXSxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 13:53:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39516 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404216AbgKXSxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 13:53:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606243999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v8XWfhYTIzwcRPPb/ukFMGj8erRQ0t+IWv7he593zZw=;
        b=EC0jH4PboKUJKgYA+rwgzioWJKcp7S7j0WbdXIlFZsltE2oKyVJGiXShAqhEERrg3rGzXR
        vtlTdUzh8CNPHDar0bWRuG7L2awTMhLRy1BnE/sGoyQSk+kOj4bExo1B2ViTQahITN8lCb
        cnavqxnyTH2KovM80RoLFl8Se9EdFzE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-obr2rKiZO0WzsoatfpSWaA-1; Tue, 24 Nov 2020 13:53:15 -0500
X-MC-Unique: obr2rKiZO0WzsoatfpSWaA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23CFD106B80C;
        Tue, 24 Nov 2020 18:53:14 +0000 (UTC)
Received: from ovpn-113-119.ams2.redhat.com (ovpn-113-119.ams2.redhat.com [10.36.113.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E16C5C1A3;
        Tue, 24 Nov 2020 18:53:11 +0000 (UTC)
Message-ID: <c110f036c113f3b8154c8671ce376d555b6f2b5a.camel@redhat.com>
Subject: Re: [PATCH net-next] mptcp: be careful on MPTCP-level ack.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Date:   Tue, 24 Nov 2020 19:53:10 +0100
In-Reply-To: <20201124100809.08360e4c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <722e1a13493897c7cc194035e9b394e0dbeeb1af.1606213920.git.pabeni@redhat.com>
         <20201124100809.08360e4c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-11-24 at 10:08 -0800, Jakub Kicinski wrote:
> On Tue, 24 Nov 2020 12:20:11 +0100 Paolo Abeni wrote:
> > -static void mptcp_send_ack(struct mptcp_sock *msk, bool force)
> > +static inline bool tcp_can_send_ack(const struct sock *ssk)
> > +{
> > +	return !((1 << inet_sk_state_load(ssk)) &
> > +	       (TCPF_SYN_SENT | TCPF_SYN_RECV | TCPF_TIME_WAIT | TCPF_CLOSE));
> > +}
> 
> Does the compiler really not inline this trivial static function?

whoops... That is just me adding an unneeded keyword. I'll send a v2.

Thanks,

Paolo



