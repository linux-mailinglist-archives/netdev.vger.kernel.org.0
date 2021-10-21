Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218E1435FA2
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 12:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhJUKtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 06:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230320AbhJUKtJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 06:49:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDEEF60F9E;
        Thu, 21 Oct 2021 10:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634813214;
        bh=FLnLjhHBgtzGdTkWVYXHbNaIge50qJUUvGGX1VMV0+Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jx4E6FwshH3Y8uCt/DXusv4Eyt6neenG8S52UVKlpKjqu6BNR1IZgfvSmSWxsKW1Q
         f0Nhqr/2ERm2pt/IhjMHoV7gRK2Fp0ySjUAUtXzOEPquzOMq4+ZzIXbdtTIr/T1+PK
         mGX7LSF7bAlD35+MEWu5GiCBo/Q/717zSYWoIYDLA6kkn4pNyV2aYyO9T0UGAhxDbp
         sjiDtAgUirz2Glz2xQ5DCBElInFneWlHAnEES+fVJJdCDA9y5q1BJs9yjc6yd/ML1X
         GAPPy9Z35QqUkhVzodkTT0KA1w2PkeT2RJhE11VaLH+JNQPYzCa0itp/6A64ZQuZBg
         eP6YXheGoMRhw==
Date:   Thu, 21 Oct 2021 12:46:50 +0200
From:   Simon Horman <horms@kernel.org>
To:     =?utf-8?B?Ss61YW4=?= Sacren <sakiwit@gmail.com>
Cc:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: qed_ptp: fix redundant check of rc and
 against -EINVAL
Message-ID: <20211021104650.GB26665@kernel.org>
References: <cover.1634621525.git.sakiwit@gmail.com>
 <492df79e1ae204ec455973e22002ca2c62c41d1e.1634621525.git.sakiwit@gmail.com>
 <20211020084835.GB3935@kernel.org>
 <YXEYVC4gBC4JC7t9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YXEYVC4gBC4JC7t9@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 01:35:48AM -0600, Jεan Sacren wrote:
> From: Simon Horman <horms@kernel.org>
> Date: Wed, 20 Oct 2021 10:48:35 +0200
> >
> > On Tue, Oct 19, 2021 at 12:26:41AM -0600, Jεan Sacren wrote:
> > > From: Jean Sacren <sakiwit@gmail.com>
> > > 
> > > We should first check rc alone and then check it against -EINVAL to
> > > avoid repeating the same operation.
> > > 
> > > With this change, we could also use constant 0 for return.
> > > 
> > > Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> > > ---
> > >  drivers/net/ethernet/qlogic/qed/qed_ptp.c | 12 +++++++-----
> > >  1 file changed, 7 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/qlogic/qed/qed_ptp.c b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
> > > index 2c62d732e5c2..c927ff409109 100644
> > > --- a/drivers/net/ethernet/qlogic/qed/qed_ptp.c
> > > +++ b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
> > > @@ -52,9 +52,9 @@ static int qed_ptp_res_lock(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
> > >  	qed_mcp_resc_lock_default_init(&params, NULL, resource, true);
> > >  
> > >  	rc = qed_mcp_resc_lock(p_hwfn, p_ptt, &params);
> > > -	if (rc && rc != -EINVAL) {
> > > -		return rc;
> > > -	} else if (rc == -EINVAL) {
> > > +	if (rc) {
> > > +		if (rc != -EINVAL)
> > > +			return rc;
> > >  		/* MFW doesn't support resource locking, first PF on the port
> > >  		 * has lock ownership.
> > >  		 */
> > > @@ -63,12 +63,14 @@ static int qed_ptp_res_lock(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
> > >  
> > >  		DP_INFO(p_hwfn, "PF doesn't have lock ownership\n");
> > >  		return -EBUSY;
> > > -	} else if (!rc && !params.b_granted) {
> > > +	}
> > > +
> > > +	if (!params.b_granted) {
> > 
> > Can it be the case where the condition above is met and !rc is false?
> > If so your patch seems to have changed the logic of this function.
> 
> Mr. Horman,
> 
> I'm so much appreciative to you for the review.  I'm so sorry this patch
> is wrong.  I redid the patch.  Could you please help me review it?
> 
> I did verify at the point where we check (!params.b_granted), !rc is
> always true.  Earlier when we check rc alone, it has to be 0 to let it
> reach the point where we check (!params.b_granted).  If it is not 0, it
> will hit one of the returns in the branch.
> 
> I'll add the following text in the changelog to curb the confusion I
> incur.  What do you think?
> 
> We should also remove the check of !rc in (!rc && !params.b_granted)
> since it is always true.

Thanks I see that now, and I agree that your patch doesn't change the logic
of the code (as far as I can tell).

Reviewed-by: Simon Horman <horms@kernel.org>

