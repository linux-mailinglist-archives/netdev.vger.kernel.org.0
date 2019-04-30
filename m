Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6438BEEDA
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 04:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729945AbfD3Ct4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 22:49:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35002 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729803AbfD3Ct4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 22:49:56 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B8FED133F9EF4;
        Mon, 29 Apr 2019 19:49:54 -0700 (PDT)
Date:   Mon, 29 Apr 2019 22:49:51 -0400 (EDT)
Message-Id: <20190429.224951.1389806535373048089.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, dsa@cumulusnetworks.com,
        pablo@netfilter.org, johannes.berg@intel.com
Subject: Re: [PATCH 2/6] netlink: extend policy range validation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190426121306.10871-3-johannes@sipsolutions.net>
References: <20190426121306.10871-1-johannes@sipsolutions.net>
        <20190426121306.10871-3-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Apr 2019 19:49:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 26 Apr 2019 14:13:02 +0200

>   *                         NLA_POLICY_RANGE() macros.
> + *    NLA_U8,
> + *    NLA_U16,
> + *    NLA_U32,
> + *    NLA_U64              If the validation_type field instead is set to
> + *                         NLA_VALIDATE_RANGE_PTR, `range' must be a pointer
> + *                         to a struct netlink_range_validation that indicates
> + *                         the min/max values.
> + *                         Use NLA_POLICY_FULL_RANGE().
> + *    NLA_S8,
> + *    NLA_S16,
> + *    NLA_S32,
> + *    NLA_S64              If the validation_type field instead is set to
> + *                         NLA_VALIDATE_RANGE_PTR, `range_signed' must be a
> + *                         pointer to a struct netlink_range_validation_signed
> + *                         that indicates the min/max values.
> + *                         Use NLA_POLICY_FULL_RANGE_SIGNED().

Documentation and datastructure says that "range_signed" member should be set
for signed ranges, however:

> +#define NLA_POLICY_FULL_RANGE(tp, _range) {		\
> +	.type = NLA_ENSURE_UINT_TYPE(tp),		\
> +	.validation_type = NLA_VALIDATE_RANGE_PTR,	\
> +	.range = _range,				\
> +}
> +
> +#define NLA_POLICY_FULL_RANGE_SIGNED(tp, _range) {	\
> +	.type = NLA_ENSURE_SINT_TYPE(tp),		\
> +	.validation_type = NLA_VALIDATE_RANGE_PTR,	\
> +	.range = _range,				\
> +}

The NLA_POLICY_FULL_RANGE_SIGNED macros sets 'range' not 'range_signed'.

Also, since range and range_signed are in a union however there is only one
NLA_VALIDATE_RANGE_PTR type, how does one differentiate between signed and
unsigned ranges exactly?

Thanks.
