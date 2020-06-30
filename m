Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F058C20F9D6
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 18:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389674AbgF3Qv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 12:51:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:38914 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389658AbgF3Qvz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 12:51:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9742CADFF;
        Tue, 30 Jun 2020 16:51:53 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 21C9F604DC; Tue, 30 Jun 2020 18:51:53 +0200 (CEST)
Date:   Tue, 30 Jun 2020 18:51:53 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Amit Cohen <amitc@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        o.rempel@pengutronix.de, andrew@lunn.ch, f.fainelli@gmail.com,
        jacob.e.keller@intel.com, mlxsw@mellanox.com
Subject: Re: [PATCH ethtool 2/3] common: add infrastructure to convert kernel
 values to userspace strings
Message-ID: <20200630165153.fipa5y2ljq4cbssy@lion.mk-sys.cz>
References: <20200630092412.11432-1-amitc@mellanox.com>
 <20200630092412.11432-3-amitc@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630092412.11432-3-amitc@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 12:24:11PM +0300, Amit Cohen wrote:
> Add enums and functions to covert extended state values sent from kernel to
> appropriate strings to expose in userspace.
> 
> Signed-off-by: Amit Cohen <amitc@mellanox.com>
> ---
>  common.c | 171 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  common.h |   2 +
>  2 files changed, 173 insertions(+)
> 
> diff --git a/common.c b/common.c
> index 2630e73..ac848f7 100644
> --- a/common.c
> +++ b/common.c
> @@ -127,6 +127,177 @@ static char *unparse_wolopts(int wolopts)
>  	return buf;
>  }
>  
> +enum link_ext_state {
> +	ETHTOOL_LINK_EXT_STATE_AUTONEG,
> +	ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE,
> +	ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH,
> +	ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY,
> +	ETHTOOL_LINK_EXT_STATE_NO_CABLE,
> +	ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE,
> +	ETHTOOL_LINK_EXT_STATE_EEPROM_ISSUE,
> +	ETHTOOL_LINK_EXT_STATE_CALIBRATION_FAILURE,
> +	ETHTOOL_LINK_EXT_STATE_POWER_BUDGET_EXCEEDED,
> +	ETHTOOL_LINK_EXT_STATE_OVERHEAT,
> +};
> +
> +enum link_ext_substate_autoneg {
> +	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED = 1,
> +	ETHTOOL_LINK_EXT_SUBSTATE_AN_ACK_NOT_RECEIVED,
> +	ETHTOOL_LINK_EXT_SUBSTATE_AN_NEXT_PAGE_EXCHANGE_FAILED,
> +	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED_FORCE_MODE,
> +	ETHTOOL_LINK_EXT_SUBSTATE_AN_FEC_MISMATCH_DURING_OVERRIDE,
> +	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_HCD,
> +};
> +
> +enum link_ext_substate_link_training {
> +	ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_FRAME_LOCK_NOT_ACQUIRED = 1,
> +	ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_INHIBIT_TIMEOUT,
> +	ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_PARTNER_DID_NOT_SET_RECEIVER_READY,
> +	ETHTOOL_LINK_EXT_SUBSTATE_LT_REMOTE_FAULT,
> +};
> +
> +enum link_ext_substate_link_logical_mismatch {
> +	ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_BLOCK_LOCK = 1,
> +	ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_AM_LOCK,
> +	ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_GET_ALIGN_STATUS,
> +	ETHTOOL_LINK_EXT_SUBSTATE_LLM_FC_FEC_IS_NOT_LOCKED,
> +	ETHTOOL_LINK_EXT_SUBSTATE_LLM_RS_FEC_IS_NOT_LOCKED,
> +};
> +
> +enum link_ext_substate_bad_signal_integrity {
> +	ETHTOOL_LINK_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS = 1,
> +	ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE,
> +};
> +
> +enum ethtool_link_ext_substate_cable_issue {
> +	ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE = 1,
> +	ETHTOOL_LINK_EXT_SUBSTATE_CI_CABLE_TEST_FAILURE,
> +};

Once you update uapi/linux/ethtool.h, these constants will be defined
there so that there is no need to duplicate them here.

> +
> +const char *link_ext_state_get(uint8_t link_ext_state_val)
> +{
> +	switch (link_ext_state_val) {
> +	case ETHTOOL_LINK_EXT_STATE_AUTONEG:
> +		return "Autoneg";
> +	case ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE:
> +		return "Link training failure";
> +	case ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH:
> +		return "Logical mismatch";
> +	case ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY:
> +		return "Bad signal integrity";
> +	case ETHTOOL_LINK_EXT_STATE_NO_CABLE:
> +		return "No cable";
> +	case ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE:
> +		return "Cable issue";
> +	case ETHTOOL_LINK_EXT_STATE_EEPROM_ISSUE:
> +		return "EEPROM issue";
> +	case ETHTOOL_LINK_EXT_STATE_CALIBRATION_FAILURE:
> +		return "Calibration failure";
> +	case ETHTOOL_LINK_EXT_STATE_POWER_BUDGET_EXCEEDED:
> +		return "Power budget exceeded";
> +	case ETHTOOL_LINK_EXT_STATE_OVERHEAT:
> +		return "Overheat";
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +static const char *autoneg_link_ext_substate_get(uint8_t link_ext_substate_val)
> +{
> +	switch (link_ext_substate_val) {
> +	case ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED:
> +		return "No partner detected";
> +	case ETHTOOL_LINK_EXT_SUBSTATE_AN_ACK_NOT_RECEIVED:
> +		return "Ack not received";
> +	case ETHTOOL_LINK_EXT_SUBSTATE_AN_NEXT_PAGE_EXCHANGE_FAILED:
> +		return "Next page exchange failed";
> +	case ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED_FORCE_MODE:
> +		return "No partner detected during force mode";
> +	case ETHTOOL_LINK_EXT_SUBSTATE_AN_FEC_MISMATCH_DURING_OVERRIDE:
> +		return "FEC mismatch during override";
> +	case ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_HCD:
> +		return "No HCD";
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +static const char *link_training_link_ext_substate_get(uint8_t link_ext_substate_val)
> +{
> +	switch (link_ext_substate_val) {
> +	case ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_FRAME_LOCK_NOT_ACQUIRED:
> +		return "KR frame lock not acquired";
> +	case ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_INHIBIT_TIMEOUT:
> +		return "KR link inhibit timeout";
> +	case ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_PARTNER_DID_NOT_SET_RECEIVER_READY:
> +		return "KR Link partner did not set receiver ready";
> +	case ETHTOOL_LINK_EXT_SUBSTATE_LT_REMOTE_FAULT:
> +		return "Remote side is not ready yet";
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +static const char *link_logical_mismatch_link_ext_substate_get(uint8_t link_ext_substate_val)
> +{
> +	switch (link_ext_substate_val) {
> +	case ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_BLOCK_LOCK:
> +		return "PCS did not acquire block lock";
> +	case ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_AM_LOCK:
> +		return "PCS did not acquire AM lock";
> +	case ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_GET_ALIGN_STATUS:
> +		return "PCS did not get align_status";
> +	case ETHTOOL_LINK_EXT_SUBSTATE_LLM_FC_FEC_IS_NOT_LOCKED:
> +		return "FC FEC is not locked";
> +	case ETHTOOL_LINK_EXT_SUBSTATE_LLM_RS_FEC_IS_NOT_LOCKED:
> +		return "RS FEC is not locked";
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +static const char *bad_signal_integrity_link_ext_substate_get(uint8_t link_ext_substate_val)
> +{
> +	switch (link_ext_substate_val) {
> +	case ETHTOOL_LINK_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS:
> +		return "Large number of physical errors";
> +	case ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE:
> +		return "Unsupported rate";
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +static const char *cable_issue_link_ext_substate_get(uint8_t link_ext_substate_val)
> +{
> +	switch (link_ext_substate_val) {
> +	case ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE:
> +		return "Unsupported cable";
> +	case ETHTOOL_LINK_EXT_SUBSTATE_CI_CABLE_TEST_FAILURE:
> +		return "Cable test failure";
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +const char *link_ext_substate_get(uint8_t link_ext_state_val, uint8_t link_ext_substate_val)
> +{
> +	switch (link_ext_state_val) {
> +	case ETHTOOL_LINK_EXT_STATE_AUTONEG:
> +		return autoneg_link_ext_substate_get(link_ext_substate_val);
> +	case ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE:
> +		return link_training_link_ext_substate_get(link_ext_substate_val);
> +	case ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH:
> +		return link_logical_mismatch_link_ext_substate_get(link_ext_substate_val);
> +	case ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY:
> +		return bad_signal_integrity_link_ext_substate_get(link_ext_substate_val);
> +	case ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE:
> +		return cable_issue_link_ext_substate_get(link_ext_substate_val);
> +	default:
> +		return NULL;
> +	}
> +}

Files common.c and common.h contain common code used by both ioctl and
netlink implementations. These helpers are only going to be used by
netlink code so that you can put them into netlink/settings.c

Personally, I would find string tables easier to read and update than
switch statements but that's a matter of taste so I don't feel strong
about it.

Michal

> diff --git a/common.h b/common.h
> index b74fdfa..26bec2f 100644
> --- a/common.h
> +++ b/common.h
> @@ -39,6 +39,8 @@ struct off_flag_def {
>  extern const struct off_flag_def off_flag_def[OFF_FLAG_DEF_SIZE];
>  
>  void print_flags(const struct flag_info *info, unsigned int n_info, u32 value);
> +const char *link_ext_state_get(uint8_t link_ext_state_val);
> +const char *link_ext_substate_get(uint8_t link_ext_state_val, uint8_t link_ext_substate_val);
>  int dump_wol(struct ethtool_wolinfo *wol);
>  void dump_mdix(u8 mdix, u8 mdix_ctrl);
>  
> -- 
> 2.20.1
> 
